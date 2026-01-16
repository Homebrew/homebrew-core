class Wv2 < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wvware/wv2-0.4.2.tar.bz2"
  sha256 "9f2b6d3910cb0e29c9ff432f935a594ceec0101bca46ba2fc251aff251ee38dc"
  license all_of: [
    "LGPL-2.0-only",
    "LGPL-2.0-or-later", # ustring files from KDE project
    "LGPL-2.1-only", # zcodec files
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/wv2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ab51a5126a4df61b38dd41445e5d456b7878326d9c4f9fec306abf45f3989730"
    sha256 cellar: :any,                 arm64_sequoia:  "0b9e9d8d06ee14ba09ec9f467e24aba00ecc63966bb877fc88a3868a2fb2041c"
    sha256 cellar: :any,                 arm64_sonoma:   "ab4eca06cc176e58df0a6d57de60929427e68ce2d8dc1fc9f71b2a15a88c59d3"
    sha256 cellar: :any,                 arm64_ventura:  "590dea1f89ca9fe964215ad6b338aa92ca782157d77bb867a568c380cf9259f0"
    sha256 cellar: :any,                 arm64_monterey: "dda217f7db1f6f78199bb54741c836013f9bc563641925be66e76fee4f001738"
    sha256 cellar: :any,                 arm64_big_sur:  "e757d5cf4bd8db93cd2b4383b38c748ea78f0f301d1740aa661ec35ee9e9ea1d"
    sha256 cellar: :any,                 sonoma:         "4e7812b4c35074f80f86a7357e6b2d065fe69c6a7fc45395d8c54748d742171e"
    sha256 cellar: :any,                 ventura:        "f9dec0774e036ac09259037d18e036fa27098f72e5ce2f4ce0386e484e3a19eb"
    sha256 cellar: :any,                 monterey:       "2ad3a28d44f4fbdfc073a3de3cb1067497d718478eb33d678dbe12cad6c905ef"
    sha256 cellar: :any,                 big_sur:        "097b7d4e10b4ef00d8298ef897acb9baa3c9b84aa0b7416e4e561700e8ab408b"
    sha256 cellar: :any,                 catalina:       "944451190aa61c6ea3dd74fffbc9e92e999b8eeb559a46f4c4708d5f9b4f154f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "518a054d34f8325f987b1ff4fbc61ad9d2966c61f880f9ead78d461927dec15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bd22b4bd66ddf417a1ee0882ca0dfc3b4bcb218d50e890a28a1752d5e4c546b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libgsf"

  uses_from_macos "zlib"

  # Temporary test resource for bottles built before testole.doc was added.
  resource "testole.doc" do
    url "https://sourceforge.net/p/wvware/svn/2/tree/wv2-trunk/tests/testole.doc?format=raw"
    sha256 "fd3a5e28d96655fa320c3118f5ccdc6435034513779b1f59f88e8d8892e78954"
  end

  # Remove .la file creation logic it does not work with CMake 4, and .la files
  # are cleaned up post-build.
  patch :DATA

  def install
    ENV.append "LDFLAGS", "-lgobject-2.0" # work around broken detection
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    # Help libgsf find its libxml2 dependency. It is not directly used by wv2
    ENV.append "CXXFLAGS", "-I#{Formula["libxml2"].include}/libxml2" unless OS.mac?

    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "tests/testole.doc"
  end

  test do
    testpath.install resource("testole.doc")

    (testpath/"test.cpp").write <<~CPP
      #include <cstdlib>
      #include <iostream>
      #include <string>

      #include <stdio.h>
      #include <wv2/parser.h>
      #include <wv2/parserfactory.h>
      #include <wv2/global.h>

      using namespace wvWare;

      void test( bool result, const std::string& failureMessage, const std::string& successMessage = "" )
      {
          if ( result ) {
              if ( !successMessage.empty() )
                  std::cerr << successMessage << std::endl;
          }
          else {
              std::cerr << failureMessage << std::endl;
              std::cerr << "Test NOT finished successfully." << std::endl;
              ::exit( 1 );
          }
      }

      void test( bool result )
      {
          test( result, "Failed", "Passed" );
      }

      // A small testcase for the parser (Word97)
      int main( int argc, char** argv )
      {
          std::string file;
          file = "testole.doc";

          std::cerr << "Testing the parser with " << file << "..." << std::endl;

          SharedPtr<Parser> parser( ParserFactory::createParser( file ) );
          std::cerr << "Trying... " << std::endl;
          if ( parser )
              test ( parser->parse() );
          std::cerr << "Done." << std::endl;

          return 0;
      }
    CPP

    wv2_flags = shell_output("#{bin}/wv2-config --cflags --libs").chomp.split
    system ENV.cxx, "test.cpp", "-L#{Formula["libgsf"].lib}",
           "-L#{Formula["glib"].lib}", *wv2_flags, "-o", "test"
    assert_match "Done", shell_output("#{testpath}/test 2>&1 testole.doc")
  end
end

__END__
--- a/cmake/MacroCreateLibtoolFile.cmake
+++ b/cmake/MacroCreateLibtoolFile.cmake
@@ -9,45 +9,4 @@ MACRO(GET_TARGET_PROPERTY_WITH_DEFAULT _variable _target _property _default_valu
 ENDMACRO (GET_TARGET_PROPERTY_WITH_DEFAULT)

 MACRO(CREATE_LIBTOOL_FILE _target _install_DIR)
-  GET_TARGET_PROPERTY(_target_location ${_target} LOCATION)
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_static_lib ${_target} STATIC_LIB "")
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_dependency_libs ${_target} LT_DEPENDENCY_LIBS "")
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_current ${_target} LT_VERSION_CURRENT 0)
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_age ${_target} LT_VERSION_AGE 0)
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_revision ${_target} LT_VERSION_REVISION 0)
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_installed ${_target} LT_INSTALLED yes)
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_shouldnotlink ${_target} LT_SHOULDNOTLINK yes)
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_dlopen ${_target} LT_DLOPEN "")
-  GET_TARGET_PROPERTY_WITH_DEFAULT(_target_dlpreopen ${_target} LT_DLPREOPEN "")
-  GET_FILENAME_COMPONENT(_laname ${_target_location} NAME_WE)
-  GET_FILENAME_COMPONENT(_soname ${_target_location} NAME)
-  SET(_laname ${PROJECT_BINARY_DIR}/${_laname}.la)
-  FILE(WRITE ${_laname} "# ${_laname} - a libtool library file\n")
-  FILE(WRITE ${_laname} "# Generated by CMake ${CMAKE_VERSION} (like GNU libtool)\n")
-  FILE(WRITE ${_laname} "\n# Please DO NOT delete this file!\n# It is necessary for linking the library with libtool.\n\n" )
-  FILE(APPEND ${_laname} "# The name that we can dlopen(3).\n")
-  FILE(APPEND ${_laname} "dlname='${_soname}'\n\n")
-  FILE(APPEND ${_laname} "# Names of this library.\n")
-  FILE(APPEND ${_laname} "library_names='${_soname}.${_target_current}.${_target_age}.${_target_revision} ${_soname}.${_target_current} ${_soname}'\n\n")
-  FILE(APPEND ${_laname} "# The name of the static archive.\n")
-  FILE(APPEND ${_laname} "old_library='${_target_static_lib}'\n\n")
-  FILE(APPEND ${_laname} "# Libraries that this one depends upon.\n")
-  FILE(APPEND ${_laname} "dependency_libs='${_target_dependency_libs}'\n\n")
-  FILE(APPEND ${_laname} "# Names of additional weak libraries provided by this library\n")
-  FILE(APPEND ${_laname} "weak_library_names=''\n\n")
-  FILE(APPEND ${_laname} "# Version information for ${_laname}.\n")
-  FILE(APPEND ${_laname} "current=${_target_current}\n")
-  FILE(APPEND ${_laname} "age=${_target_age}\n")
-  FILE(APPEND ${_laname} "revision=${_target_revision}\n\n")
-  FILE(APPEND ${_laname} "# Is this an already installed library?\n")
-  FILE(APPEND ${_laname} "installed=${_target_installed}\n\n")
-  FILE(APPEND ${_laname} "# Should we warn about portability when linking against -modules?\n")
-  FILE(APPEND ${_laname} "shouldnotlink=${_target_shouldnotlink}\n\n")
-  FILE(APPEND ${_laname} "# Files to dlopen/dlpreopen\n")
-  FILE(APPEND ${_laname} "dlopen='${_target_dlopen}'\n")
-  FILE(APPEND ${_laname} "dlpreopen='${_target_dlpreopen}'\n\n")
-  FILE(APPEND ${_laname} "# Directory that this library needs to be installed in:\n")
-  FILE(APPEND ${_laname} "libdir='${CMAKE_INSTALL_PREFIX}${_install_DIR}'\n")
-#  INSTALL( FILES ${_laname} ${_soname}  DESTINATION ${CMAKE_INSTALL_PREFIX}${_install_DIR})
-  INSTALL( FILES ${_laname} DESTINATION ${CMAKE_INSTALL_PREFIX}${_install_DIR})
 ENDMACRO(CREATE_LIBTOOL_FILE)
