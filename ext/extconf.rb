require 'mkmf'

def inc_paths lib, defaults
  path = %x{pkg-config #{lib} --cflags 2>/dev/null}.strip
  path.size > 0 ? path : defaults.map {|name| "-I#{name}"}.join(' ')
end

def lib_paths lib, defaults
  path = %x{pkg-config #{lib}  --libs-only-L 2>/dev/null}.strip
  path.size > 0 ? path : defaults.map {|name| "-L#{name}"}.join(' ')
end

def lib_names lib, defaults
  path = %x{pkg-config #{lib}  --libs-only-l 2>/dev/null}.strip
  path.size > 0 ? path : defaults.map {|name| "-l#{name}"}.join(' ')
end

$CFLAGS  = inc_paths('opencv', %w(/usr/include/opencv)) + ' -Wall'
$LDFLAGS = lib_names('opencv', %w(highgui core_c))

headers = [ 'stdio.h', 'stdlib.h', 'string.h', 'opencv2/core/core_c.h', 'opencv2/highgui/highgui_c.h' ]
lib_1   = [ 'opencv_core',  'cvInitFont',    headers ]
lib_2   = [ 'opencv_highgui', 'cvEncodeImage', headers ]

if have_header('opencv2/core/core_c.h') && have_library(*lib_1) && have_library(*lib_2)
  create_makefile 'similie'
else
  puts %q{
    Cannot find opencv headers or libraries.

    On debian based systems you can install it from apt as,
      sudo apt-get install libcv-dev libhighgui-dev

    Refer to http://opencv.willowgarage.com/wiki/InstallGuide for other platforms or operating systems.
  }

  exit 1
end
