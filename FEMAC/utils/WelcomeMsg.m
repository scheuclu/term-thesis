function [] = WelcomeMsg(type)
%http://www.network-science.de/ascii/
%style: slant

  switch(type)
    case 'pre'
      consoleline('',false);
      consoleinfo('          ______________  ______   ______            ____  ____  ______');
      consoleinfo('         / ____/ ____/  |/  /   | / ____/           / __ \/ __ \/ ____/');
      consoleinfo('        / /_  / __/ / /|_/ / /| |/ /      ______   / /_/ / /_/ / __/   ');
      consoleinfo('       / __/ / /___/ /  / / ___ / /___   /_____/  / ____/ _, _/ /___   ');
      consoleinfo('      /_/   /_____/_/  /_/_/  |_\____/           /_/   /_/ |_/_____/   ');
      consoleinfo('  ©Lehrstuhl fuer Angewandte Mechanik - Technische Universitaet Muenchnen');
      consoleline('',true);
    case 'main'

      consoleline('',false);
      consoleinfo('      ______________  ______   ______            __  ______    _____   __');
      consoleinfo('     / ____/ ____/  |/  /   | / ____/           /  |/  /   |  /  _/ | / /');
      consoleinfo('    / /_  / __/ / /|_/ / /| |/ /      ______   / /|_/ / /| |  / //  |/ / ');
      consoleinfo('   / __/ / /___/ /  / / ___ / /___   /_____/  / /  / / ___ |_/ // /|  /  ');
      consoleinfo('  /_/   /_____/_/  /_/_/  |_\____/           /_/  /_/_/  |_/___/_/ |_/   ');
      consoleinfo('  ©Lehrstuhl fuer Angewandte Mechanik - Technische Universitaet Muenchnen');
      consoleline('',true);
    case 'post'
      consoleline('',false);
      consoleinfo('       ______________  ______   ______            ____  ____  ___________');
      consoleinfo('      / ____/ ____/  |/  /   | / ____/           / __ \/ __ \/ ___/_  __/');
      consoleinfo('     / /_  / __/ / /|_/ / /| |/ /      ______   / /_/ / / / /\__ \ / /   ');
      consoleinfo('    / __/ / /___/ /  / / ___ / /___   /_____/  / ____/ /_/ /___/ // /    ');
      consoleinfo('   /_/   /_____/_/  /_/_/  |_\____/           /_/    \____//____//_/     ');
      consoleinfo('  ©Lehrstuhl fuer Angewandte Mechanik - Technische Universitaet Muenchnen');
      consoleline('',true);
    otherwise
      error('Message type not recognized');
  end


end