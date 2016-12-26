#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, inspect, sys, subprocess, pickle, shutil, argparse
from multiprocessing import Pool
from tools import *


# -----------------SETTINGS-------------------------
version=0.2
buf_file='.buffer'
clean_file='.clean'
scripts=['SConscript']
# --------------------------------------------------

# Initialize clean file data
clean=CleanFile(clean_file)


# Parsing options
arg_parser = argparse.ArgumentParser(description="Enjoy the cool scons building tool!")
arg_parser.add_argument('-c', '--clean', action='store_true', dest='clean', default=False, help='clean unversioned documents')
arg_parser.add_argument('-t', '--thorough', action='store_true', dest='thorough', default=False, help='build missing files even when sources have not changed')
arg_parser.add_argument('-j', '--multithread', action='store', dest='no_of_processes', type=int, default=1, help='create multiple build processes')
arg_parser.add_argument('-s', '--svn', action='store_true', dest='svn', default=False, help='check if all necessary files were added in svn')
arguments = arg_parser.parse_args()


if arguments.clean:
    n=0

    for d in clean.clean_paths | set([buf_file, clean_file]):
        if os.path.exists(d):
            print 'Remove: '+d
            clean.del_file(d)
            n+=1            

    print 'scons: '+str(n)+' file(s) successfully removed.'
    print 'scons: Done.'
    sys.exit()


class Buffer:
    def __init__(self, version=None, tex=dict(), svg=dict(), tikz=dict(), sub=dict(), install=dict()):
        self.version=version
        # List of tx files
        self.tex=tex
        # List of svg files
        self.svg=svg
        # List of tikz Files
        self.tikz=tikz
        # List of subFiles that are included/imported
        self.sub=sub
        self.install=install


class Global:
    base_dir=os.path.abspath(os.path.dirname(__file__))
    current_scr=__file__
    current_dir=base_dir

    tex=set()
    install=dict()
    script_paths=set(scripts)


def base_path(path):
    return os.path.relpath(path, Global.base_dir)


def scan_files(endswith, maxdepth):
    return sf(endswith, Global.current_dir, maxdepth)


def add_files(files, install_path=None):
    for f in files:
        path=os.path.relpath(os.path.join(Global.current_dir, f), Global.base_dir)

        if not os.path.exists(path):
            red('\nFile not found: '+path)
            red('Added in '+Global.current_scr+'\n')
            raise Exception

        if path.endswith('.tex'):
            Global.tex.add(FileDataTEX(path))
        elif path.endswith('.svg'):
            if install_path==None:
                red('\nNo install path specified for: '+path)
                red('Added in: '+Global.current_scr+'\n')
                raise Exception
        else:
            red('\nSuffix not accepted: '+path)
            red('Only .tex and .svg are allowed.\n')
            raise Exception

        if install_path!=None:
            Global.install[path]=platform_path(install_path)


def SConscript(scripts):
    parent_dir=Global.current_dir

    for script in scripts:
        script=platform_path(script)

        script_file=os.path.join(parent_dir, script)

        # For svn check
        Global.script_paths.add(os.path.relpath(script_file, Global.base_dir))

        # Local SConscript file
        if os.path.exists(script_file+'_local') and arguments.svn==False:
            print 'scons: Using local SConscript file: '+os.path.relpath(script_file+'_local', Global.base_dir)
            script_file=script_file+'_local'

        # For error messages
        Global.current_scr=script_file

        # For recursion
        Global.current_dir=os.path.dirname(script_file)

        execfile(script_file, {'Global':Global, 'SConscript':SConscript, 'add_files':add_files, 'scan_files':scan_files})


class FileData:
    def __init__(self, path):
        self.path=path
        self.checksum=self.calculate_checksum()

    def calculate_checksum(self):
        md5cs=hashlib.md5()
        fh=open(self.path, 'rb')
        while True:
            buf=fh.read(4096)
            if not buf : break
            md5cs.update(buf)
        fh.close()

        return md5cs.hexdigest()

    def update_checksum(self):
        old_checksum=self.checksum
        self.checksum=self.calculate_checksum()

        return self.checksum==old_checksum
    
    def __hash__(self):
        return hash((self.path, self.checksum))

    def __eq__(self, other):
        return (self.path, self.checksum)==other

    def __str__(self):
        return self.path

class FileDataTEX(FileData):
    """
    This is the basis class to save the necessary file data of a tex file
    """
    compilation=set()
    check_sub=set() # check for removal from sub dictionary
    changed_sub=set() # changed files from sub dictionary
    n_tex_failed=0

    def __init__(self, path):
        FileData.__init__(self, path)

        self.imported_svg=set()
        self.included_svg=set()
        self.imported_tikz=set()
        self.included_tikz=set()        
        self.included_pdf=set()
        self.included_sub=set()

        self.parents=set()
        
        # Mother file that includes the file
        self.mothers = set()


    def clear(self, svg, tikz, sub):
        self.update(svg, tikz, sub, True)

    def update(self, svg, tikz, sub, clear=False):

        added_sub=set()

        if clear==True:
            imported_svg=set()
            included_svg=set()
            imported_tikz=set()
            included_pdf=set()
            included_sub=set()
        else:
            imported_svg, included_svg, imported_tikz, included_pdf, included_sub = parse(self.path)

        # Deal with SVGs
        for added in imported_svg - self.imported_svg:
            self.imported_svg.add(added)

            if added not in svg:
                svg[added]=FileDataSVG(added)

            svg[added].add_imported_in(self.path)    

        for removed in self.imported_svg - imported_svg:
            self.imported_svg.remove(removed)
            svg[removed].remove_parent(self.path)

        for added in included_svg - self.included_svg:
            self.included_svg.add(added)

            if added not in svg:
                svg[added]=FileDataSVG(added)
            
            svg[added].add_included_in(self.path)

        for removed in self.included_svg - included_svg:
            self.included_svg.remove(removed)
            svg[removed].remove_parent(self.path)
        
        # Deal with tikz
        for added in imported_tikz - self.imported_tikz:
            self.imported_tikz.add(added)

            if added not in tikz:
                tikz[added]=FileDataTIKZ(added)

            tikz[added].add_imported_in(self.path, self.mothers)

        for removed in self.imported_tikz - imported_tikz:
            self.imported_tikz.remove(removed)
            tikz[removed].remove_parent(self.path)

        # Deal with subs
        for added in included_sub - self.included_sub:
            self.included_sub.add(added)

            if added not in sub:
                sub[added]=FileDataTEX(added)
                added_sub.add(added)

            sub[added].parents.add(self.path)
            
            # Save the mothers to the file
            if len(self.mothers) == 0:
                sub[added].mothers.add(self.path)
            else:
                sub[added].mothers = sub[added].mothers.union(self.mothers)

        for removed in self.included_sub - included_sub:
            self.included_sub.remove(removed)
            sub[removed].remove_parent(self.path)

        return added_sub

    def remove_parent(self, parent_path):
        self.parents.remove(parent_path)

        if len(self.parents)==0:
            FileDataTEX.check_sub.add(self.path)


class FileDataSVG(FileData):
    """
    Class that saves the necessary data for SVG files
    """
    compilation=set()
    check=set()

    def __init__(self, path):
        FileData.__init__(self, path)

        self.mothers=set()
        self.included_in=set()

    def check_consistency(self, install):
        if len(self.mothers)!=0:
            if len(self.included_in)!=0: 
                red('\nInclusion error: '+self.path)
                red('Simultaneous inclusion via \\import and \\includegraphics is not allowed.')
                red('\\import:                    '+settostr(self.mothers))
                red('\\includegraphics: '+settostr(self.included_in)+'\n')
                raise Exception
        
            if self.path in install:
                red('\nInstall error: '+self.path)
                red('Inclusion via \\import and setting install folder is not allowed.')
                red('\\import:             '+settostr(self.mothers))
                red('Install folder: '+install[path])     
                raise Exception

    def remove_parent(self, parent_path):
        self.mothers.discard(parent_path)
        self.included_in.discard(parent_path)

        if len(self.mothers)+len(self.included_in)==0:
            FileDataSVG.check.add(self.path)
        
    def add_imported_in(self, parent_path):
        self.mothers.add(parent_path)
        
        if len(self.mothers)==1:
            FileDataSVG.compilation.add(self.path)

    def add_included_in(self, parent_path):
        self.included_in.add(parent_path)
        
        if len(self.included_in)==1:
            FileDataSVG.compilation.add(self.path)
            
class FileDataTIKZ(FileData):
    """
    Class that save the necessary data for tikz-source files
    """
    compilation=set()
    check=set()

    def __init__(self, path):
        FileData.__init__(self, path)

        self.imported_in=set()
        self.mothers=set()

    def remove_parent(self, mother_path):
        print "TODO: update for mother path"
        self.mothers.discard(mother_path)

        if len(self.mothers)==0:
            FileDataTIKZ.check.add(self.path)
        
    def add_imported_in(self, parent_path, mother_paths):
        self.mothers = self.mothers.union(mother_paths)
        self.imported_in.add(parent_path)
        
        for mother in self.mothers:
            FileDataTIKZ.compilation.add((self.path,mother,parent_path))


# Execute SConscript files
print 'scons: Reading SConscript files...'
SConscript(scripts)


# --------------------------------------------------------------------
# Set elements: (path, file_data)
# sub: tex/cls/sty or any other latex source file that is not compiled
# --------------------------------------------------------------------

# Buffer file
if os.path.exists(buf_file):
    f=open(buf_file, 'r')
    try:
        # Load old buffer file
        buf=pickle.load(f) 
    except:
        # Create new buffer file
        buf=Buffer()
    finally:
        f.close()

    if buf.version!=version:
        print 'scons: Version upgrade to '+str(version)+'.'
        buf=Buffer()
    else:
        print 'scons: Using buffer file...'
else:
    buf=Buffer()

# Find the differences between the buffered tex-files and the tex-files read from the SConsscripts 
buf.tex_dif=set(buf.tex.values()).difference(Global.tex)
# Update the differences to the global tex files
Global.tex.difference_update(set(buf.tex.values()).difference(buf.tex_dif))

# For every file in the buffered sub-path check if the file has changed
for path in buf.sub:
    if os.path.exists(path):
        if not buf.sub[path].update_checksum():
            FileDataTEX.changed_sub.add(path)
    else:
        FileDataTEX.check_sub.add(path)
# For every file in the saved paths of the sconsscripts add it to the compilation
for data in Global.tex:
    path=data.path

    FileDataTEX.compilation.add(path)

     
    if path not in buf.tex:
        # if the file is not in the buffer add it
        buf.tex[path]=data
    else:
        # otherwise update the checksum data
        buf.tex[path].checksum=data.checksum

    FileDataTEX.changed_sub.update(buf.tex[path].update(buf.svg, buf.tikz, buf.sub))


for data in buf.tex_dif:
    path=data.path

    if path not in FileDataTEX.compilation:
        buf.tex[path].clear(buf.svg, buf.tikz, buf.sub)

        del buf.tex[path]


sub_parse=FileDataTEX.changed_sub.copy()

while len(sub_parse)>0:
    path=sub_parse.pop()

    added_sub=buf.sub[path].update(buf.svg, buf.tikz, buf.sub)
    sub_parse.update(added_sub)
    FileDataTEX.changed_sub.update(added_sub)

"""
Check all the files:
which should be (re-)compiled?
"""
while len(FileDataTEX.check_sub)>0:
    path=FileDataTEX.check_sub.pop()

    if len(buf.sub[path].parents)==0:
        buf.sub[path].clear(buf.svg, buf.tikz, buf.sub)
        del buf.sub[path]
        FileDataTEX.changed_sub.discard(path)


for path in FileDataSVG.check:
    if len(buf.svg[path].mothers)+len(buf.svg[path].included_in)==0:
        if path not in Global.install:
            del buf.svg[path]
            FileDataSVG.compilation.discard(path)


for path in buf.svg:
    if os.path.exists(path):
        if not buf.svg[path].update_checksum():
            FileDataSVG.compilation.add(path)
    else:
        FileDataSVG.check.add(path)
        
for path in FileDataTIKZ.check:
    if len(buf.tikz[path].mothers)+len(buf.tikz[path].included_in)==0:
        if path not in Global.install:
            del buf.tikz[path]
            FileDataTIKZ.compilation.discard(path)        
        
for path in buf.tikz:
    if os.path.exists(path):
        if not buf.tikz[path].update_checksum():
            for mother in buf.tikz[path].mothers:
                for imIn in buf.tikz[path].imported_in:
                    FileDataTIKZ.compilation.add((path, mother, imIn))
    else:
        FileDataTIKZ.check.add(path)        


# Update svg buffer (install path)
for path in Global.install:
    if path.endswith('.svg'):
        if path not in buf.svg:
            buf.svg[path]=FileDataSVG(path)
            FileDataSVG.compilation.add(path)


for path in FileDataSVG.compilation:
    FileDataTEX.changed_sub.update(buf.svg[path].mothers)
    FileDataTEX.changed_sub.update(buf.svg[path].included_in)
    
for path in FileDataTIKZ.compilation:
    FileDataTEX.changed_sub.update(buf.tikz[path[0]].mothers)


while len(FileDataTEX.changed_sub)>0:
    path=FileDataTEX.changed_sub.pop()
    
    if path in buf.tex:
        FileDataTEX.compilation.add(path)
    else:
        FileDataTEX.changed_sub.update(buf.sub[path].parents)


# Check whether built files exist
if arguments.thorough:
    for path in buf.tex:
                    
        #if not os.path.exists(path[0:-4]+'.pdf'):
        FileDataTEX.compilation.add(path)

        if path in Global.install:
            if not os.path.exists(os.path.join(Global.install[path], os.path.basename(path[0:-4]+'.pdf'))):
                FileDataTEX.compilation.add(path)

    for path in buf.svg:
        suffix=['.pdf']

        if path in Global.install:
            if not os.path.exists(os.path.join(Global.install[path], os.path.basename(path[0:-4]+'.pdf'))):
                FileDataSVG.compilation.add(path)

        if len(buf.svg[path].mothers)>0:
            suffix.append('.pdf_tex')

        for s in suffix:
            if not os.path.exists(path[0:-4]+s):
                FileDataSVG.compilation.add(path)
            

# Check svn status
if arguments.svn:
    unknown_files=set()
    unknown_folders=set()

    for line in os.popen('svn status'):
        line=line.split()
 
        if line[0]=='?':
            if os.path.isdir(line[1]):
                unknown_folders.add(line[1])
            else:
                unknown_files.add(line[1])

    needed_files=set([src_file.path for src_file in buf.tex.values() + buf.svg.values() + buf.sub.values()]) | Global.script_paths

    missing_files=unknown_files & needed_files
    missing_folders=set()

    for folder in unknown_folders:
        for needed_file in needed_files:
            if needed_file.find(folder)==0:
                missing_folders.add(folder)

    if len(missing_folders)+len(missing_files)!=0:
        red('\nNot all necessary files were added in Subversion.')

    for folder in missing_folders:
        red('Folder not added in Subversion: '+folder)

    for f in missing_files:
        red('File not added in Subversion: '+f)

    if len(missing_folders)+len(missing_files)!=0:
        red('\nPress enter to continue.')
    else:
        blue('\nCongratulations! All necessary files were added in Subversion.\nPress enter to continue.')
    raw_input()


# Compilation
print 'scons: Start Compilation...'

def prepare_install(path):
    if not os.path.isdir(path):
        os.makedirs(path)

def editpdf_tex(path):
        '''
        Search and replace certain strings that are not wanted but produced by the inkscape output
        '''
        import fileinput
        
        addLine = False
        for line in fileinput.input(os.path.abspath(path), inplace=True):
                if not addLine:
                        newstr = line
                else:
                        newstr += line
                newstr = newstr.replace('\\\\}', '\\\\ }')
                newstr = newstr.replace('{picture}', '{tikzpicture}')
                newstr = newstr.replace('\\smash','')
                if '\\put' in newstr:
                        newstr = newstr.replace('\\put(','\\node[draw] at (')
                        addLine = True
                        if newstr[-2] != '%':
                                newstr = newstr.replace("\n","\\hfill\\break ")
                if not addLine:
                        print newstr,
                elif newstr[-2] == '%':
                        newstr = newstr.replace('\\put(','\\node[draw] at (')
                        print newstr[:-2]+";%\n",
                        addLine = False

def compile_svg(path):
    buf.svg[path].check_consistency(Global.install)

    if len(buf.svg[path].mothers)>0:
        print 'Compile: inkscape -z -D --export-pdf='+path[0:-4]+'.pdf --file='+path+' --export-latex'
        sys_out=subprocess.check_output(['inkscape', '-z', '-D', '--export-pdf='+path[0:-4]+'.pdf', '--file='+path, '--export-latex'], stderr=subprocess.STDOUT)
        #editpdf_tex(path[0:-4]+'.pdf_tex')
    else:
        print 'Compile: inkscape -z -D --export-pdf='+path[0:-4]+'.pdf --file='+path
        sys_out=subprocess.check_output(['inkscape', '-z', '-D', '--export-pdf='+path[0:-4]+'.pdf', '--file='+path], stderr=subprocess.STDOUT)
        #editpdf_tex(path[0:-4]+'.pdf_tex')
        if path in Global.install:
            install_path=Global.install[path]
            prepare_install(install_path)
            print 'Install: '+os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf')
            shutil.copyfile(path[0:-4]+'.pdf', os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))

def compile_tikz(pathTuple):
    tikzFile = pathTuple[0]
    motherFile = pathTuple[1]
    inclFile = pathTuple[2]
    
    rootDir = os.getcwd()
    motherDir = os.path.abspath(os.path.dirname(motherFile))
    try:
        import tempfile
        if len(buf.tikz[tikzFile].mothers)>0:        
            fTMP = tempfile.NamedTemporaryFile(bufsize=0,suffix='.tex',dir=motherDir) # Create a temporary file
            try:
                tikzpath = ''
                # Read mother file and write it to file
                fMother = open(motherFile, 'r')
                for line in fMother.readlines():
                    if not 'font{Utopia}' in line:
                        fTMP.write(line)
                    if 'tikzexternalize' in line and 'prefix=' in line:
                        tikzpath = line.split('prefix=')[-1].split(',')[0]
                    if 'begin{document}' in line:
                        fTMP.write("\\tikzset{external/remake next}" + '\n') # Force to write new files
                        break
                    
                fMother.close()

                # Read tikz-File and write it to temporary file
                dirName = os.path.dirname(os.path.abspath(tikzFile))
                fileName = os.path.basename(os.path.abspath(tikzFile))
                
                # Force the update here!
                finclFile = open(inclFile, 'r')
                for line in finclFile.readlines():
                    if 'pgf' in line:
                        fTMP.write(line)
                    if fileName[:-5] in line:
                        break
                    
                finclFile.close()
                

                # TODO: write the line, that it has to be updated in any case!
                fTMP.write("\\tikzFile{" + dirName + os.sep + "}{" + fileName[:-5] + "}"  + '\n')
                
                # Write the end of the document
                fTMP.write("\\end{document}" + '\n')
                
                # Compile it
                path = tikzpath + fileName[:-5]
                jobname = os.path.basename(fTMP.name)[:-4]
                command = ['lualatex', '-enable-write18', '-halt-on-error', '-interaction=batchmode', '-jobname "'+ path + '"', '"\def\\tikzexternalrealjob{' + jobname +'}\input{' + jobname + '}"']
                #command = ['lualatex', '-enable-write18', fTMP.name]
                print 'Compiling tikz-File "' + tikzFile + '" of mother file "' + motherFile + '" with "' + ' '.join(command) + '"'
                # Change to the directory of the temporary file
                os.chdir(os.path.dirname(fTMP.name))
                subprocess.call(command)
                
                
            finally:
                fTMP.close()
                # Delete the builded file as well
                import glob
                for filename in glob.glob(jobname + "*"):
                    os.remove(filename) 
    finally:
        os.chdir(rootDir)
        
def compile_tex(path):
    pwd = os.getcwd()
    os.chdir(os.path.dirname(path))
    
    #bibtexcommand = ['bibtex', path.split(os.sep)[-1][:-3]+'aux']
    bibtexcommand = ['biber', path.split(os.sep)[-1][:-4]]
    glossariescommand = ['makeglossaries', path.split(os.sep)[-1][:-4]]
    
    pdflatexcommand = ['pdflatex', '-shell-escape', path.split(os.sep)[-1]]
    #latexmkcommand = ['latexmk', '-pdf', path.split(os.sep)[-1]]
    latexmkcommand = ['latexmk', '-pdf', '-pdflatex=pdflatex -shell-escape %O %S', path.split(os.sep)[-1]]
    lualatexcommand = ['lualatex', '--enable-write18', path.split(os.sep)[-1]]
    xelatexcommand = ['xelatex', '-shell-escape', path.split(os.sep)[-1]]
    
    latexcommand = pdflatexcommand
    print 'Compile: ' + ' '.join(latexcommand)

    if subprocess.call(latexcommand)!=0:
        FileDataTEX.n_tex_failed+=1

        red('\nCompilation error:\n'+path)
        red('Press enter to continue.\n')

        if raw_input()!='':
            red('Aborted\n')
            raise Exception
        else:
            buf.tex[path].checksum=0
    else:
        if not latexcommand == latexmkcommand: 
            subprocess.call(bibtexcommand)
            subprocess.call(glossariescommand)
            subprocess.call(latexcommand)
            subprocess.call(latexcommand)

    os.chdir(pwd)
    clean.clean_tex(path)

    if path in Global.install:
        install_path=Global.install[path]
        prepare_install(install_path)
        print 'Install: '+os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf')
        shutil.copyfile(path[0:-4]+'.pdf', os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))


# Update clean file data
for path in FileDataSVG.compilation:
    clean.add(path[0:-4]+'.pdf')

    if len(buf.svg[path].mothers)>0:
        clean.add(path[0:-4]+'.pdf_tex')

for path in FileDataTEX.compilation:
    clean.add_tex(path)

for path in Global.install:
    clean.add(os.path.join(Global.install[path], os.path.basename(path)[0:-4]+'.pdf'))

clean.dump()

"""
Compile all the files
"""
if arguments.no_of_processes<2:
#    for pathTuple in FileDataTIKZ.compilation:
#        compile_tikz(pathTuple)
    for path in FileDataSVG.compilation:
        compile_svg(path)
    for path in FileDataTEX.compilation:
        compile_tex(path)
else:
    # Multiprocessing
    pool=Pool(processes=arguments.no_of_processes)
    pool.map(compile_svg, FileDataSVG.compilation)
    print "TIKZ does not support multiprocessing a.t.m."
    #pool.map(compile_tikz, FileDataTIKZ.compilation)
    pool.map(compile_tex, FileDataTEX.compilation)


# Install files
for path in Global.install:
    inst=False

    if path not in FileDataSVG.compilation | FileDataTEX.compilation:
        if path not in buf.install:
            inst=True
        elif buf.install[path]!=Global.install[path]:
            inst=True

    if inst==True:
        install_path=Global.install[path]
        prepare_install(install_path)
        print 'Install: '+os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf')
        shutil.copyfile(path[0:-4]+'.pdf', os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))

    

# Save buffer file
buf.version=version
buf.install=Global.install


f=open(buf_file, 'w+')
pickle.dump(buf, f)
f.close()


print 'scons: Finished compilation ('+str(len(FileDataSVG.compilation))+' Inkscape files, '+str(len(FileDataTEX.compilation)-FileDataTEX.n_tex_failed)+' LaTeX files).'
if FileDataTEX.n_tex_failed!=0:
    print 'scons: Compilation of '+str(FileDataTEX.n_tex_failed)+' LaTeX files failed.'

print 'scons: Done.'

