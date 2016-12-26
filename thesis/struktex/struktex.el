
;;; struktex.el --- AUCTeX style for `struktex.sty'

;; Copyright (C) 2006 Free Software Foundation, Inc.

;; Author: J. Hoffmann <j.hoffmann_(at)_fh-aachen.de>
;; Maintainer: j.hoffmann_(at)_fh-aachen.de
;; Created: 2006/01/17
;; Keywords: tex

;;; Commentary:
;;  This file adds support for `struktex.sty'

;;; Code:
(TeX-add-style-hook
 "struktex"
 (lambda ()
   ;; Add declaration to the list of environments which have an optional
   ;; argument for each item.
   (add-to-list 'LaTeX-item-list
                '("declaration" . LaTeX-item-argument))
   (LaTeX-add-environments
    "centernss"
    '("struktogramm" LaTeX-env-struktogramm)
    '("declaration" LaTeX-env-declaration))
   (TeX-add-symbols
    '("PositionNSS" 1)
    '("assert" [ "Height" ] "Assertion")
    '("assign" [ "Height" ] "Statement")
    "StrukTeX"
    '("case" TeX-mac-case)
    "switch" "Condition"
    "caseend"
    '("declarationtitle" "Title")
    '("description" "Name" "Meaning")
    "emptyset"
    '("exit" [ "Height" ] "What" )
    '("forever" TeX-mac-forever)
    "foreverend"
    '("ifthenelse" TeX-mac-ifthenelse)
    "change"
    "ifend"
    '("inparallel" TeX-mac-inparallel)
    '("task" "Description")
    "inparallelend"
    "sProofOn"
    "sProofOff"
    '("until" TeX-mac-until)
    "untilend"
    '("while" TeX-mac-while)
    "whileend"
    '("return" [ "Height" ] "Return value")
    '("sub" [ "Height" ] "Task")
    '("CenterNssFile" TeX-arg-file)
    '("centernssfile" TeX-arg-file))
   (TeX-run-style-hooks
    "pict2e"
    "emlines2"
    "curves"
    "struktxp"
    "struktxf"
    "ifthen")
   ;; Filling
   ;; Fontification
   ))

(defun LaTeX-env-struktogramm (environment)
  "Insert ENVIRONMENT with width, height specifications and optional title."
  (let ((width (read-string "Width: "))
        (height (read-string "Height: "))
        (title (read-string "Title (optional): ")))
    (LaTeX-insert-environment environment
                              (concat
                               (format "(%s,%s)" width height)
                               (if (not (zerop (length title)))
                                   (format "[%s]" title))))))

(defun LaTeX-env-declaration (environment)
  "Insert ENVIRONMENT with an optional title."
  (let ((title (read-string "Title (optional): ")))
    (LaTeX-insert-environment environment
                               (if (not (zerop (length title)))
                                   (format "[%s]" title)))))

(defun TeX-mac-case (macro)
  "Insert \\case with all arguments, the needed \\switch(es) and the final \\caseend.
These are optional height and the required arguments slope, number of cases,
condition, and the texts for the different cases"
  (let ((height (read-string "Height (optional): "))
        (slope (read-string "Slope: "))
        (number (read-string "Number of cases: "))
        (condition (read-string "Condition: "))
        (text (read-string "Case no. 1: "))
        (count 1)
        )
    (setq number-int (string-to-number number))
    (insert (concat (if (not (zerop (length height)))
                        (format "[%s]" height))
                    (format "{%s}{%s}{%s}{%s}"
                            slope number condition text)))
    (while (< count number-int)
      (end-of-line)
      (newline-and-indent)
      (newline-and-indent)
      (setq prompt (format "Case no. %d: " (+ 1 count)))
      (insert (format "\\switch{%s}" (read-string prompt)))
      (setq count (1+ count)))
      (end-of-line)
      (newline-and-indent)
      (newline-and-indent)
      (insert "\\caseend")))

(defun TeX-mac-forever (macro)
  "Insert \\forever-block with all arguments.
This is only the optional height"
  (let ((height (read-string "Height (optional): ")))
    (insert (if (not (zerop (length height)))
                (format "[%s]" height)))
    (end-of-line)
    (newline-and-indent)
    (newline-and-indent)
    (insert "\\foreverend")))

(defun TeX-mac-ifthenelse (macro)
  "Insert \\ifthenelse with all arguments.
These are optional height and the required arguments left slope, right slope,
condition, and the possible values of the condition"
  (let ((height (read-string "Height (optional): "))
        (lslope (read-string "Left slope: "))
        (rslope (read-string "Right slope: "))
        (condition (read-string "Condition: "))
        (conditionvl (read-string "Condition value left: "))
        (conditionvr (read-string "Condition value right: ")))
    (insert (concat (if (not (zerop (length height)))
                        (format "[%s]" height))
                    (format "{%s}{%s}{%s}{%s}{%s}"
                            lslope rslope condition conditionvl conditionvr)))
    (end-of-line)
    (newline-and-indent)
    (newline-and-indent)
    (insert "\\change")
    (end-of-line)
    (newline-and-indent)
    (newline-and-indent)
    (insert "\\ifend")))

(defun TeX-mac-inparallel (macro)
  "Insert \\inparallel with all arguments, the needed \\task(es) and the final \\inparallelend.
These are optional height and the required arguments number of tasks
and the descriptions for the parallel tasks"
  (let ((height (read-string "Height (optional): "))
        (number (read-string "Number of parallel tasks: "))
        (text (read-string "Task no. 1: "))
        (count 1)
        )
    (setq number-int (string-to-number number))
    (insert (concat (if (not (zerop (length height)))
                        (format "[%s]" height))
                    (format "{%s}{%s}" number text)))
    (while (< count number-int)
      (end-of-line)
      (newline-and-indent)
      (newline-and-indent)
      (setq prompt (format "Task no. %d: " (+ 1 count)))
      (insert (format "\\task{%s}" (read-string prompt)))
      (setq count (1+ count)))
      (end-of-line)
      (newline-and-indent)
      (newline-and-indent)
      (insert "\\inparallelend")))

(defun TeX-mac-until (macro)
  "Insert \\until with all arguments.
These are the optional height and the required argument condition"
  (let ((height (read-string "Height (optional): "))
        (condition (read-string "Condition: ")))
    (insert (concat (if (not (zerop (length height)))
                        (format "[%s]" height))
                    (format "{%s}" condition)))
    (end-of-line)
    (newline-and-indent)
    (newline-and-indent)
    (insert "\\untilend")))

(defun TeX-mac-while (macro)
  "Insert \\while with all arguments.
These are the optional height and the required argument condition"
  (let ((height (read-string "Height (optional): "))
        (condition (read-string "Condition: ")))
    (insert (concat (if (not (zerop (length height)))
                        (format "[%s]" height))
                    (format "{-%s-}" condition)))
    (end-of-line)
    (newline-and-indent)
    (newline-and-indent)
    (insert "\\whileend")))

(defvar LaTeX-struktex-package-options '("curves" "draft" "emlines" "final"
                                         "pict2e" "anygradient" "verification"
                                         "nofiller")
  "Package options for the struktex package.")

;;; struktex.el ends here.
