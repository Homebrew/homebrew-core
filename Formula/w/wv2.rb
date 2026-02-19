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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d264df90b7b45b15d1aafa19c346cad1fa08f825411fcb219bd42250be96930b"
    sha256 cellar: :any,                 arm64_sequoia: "af5f8163837dec3fe37596271172275a69a09029bccaf811776ecf8140b705dc"
    sha256 cellar: :any,                 arm64_sonoma:  "b39554aadf87fc57071d72c9f41836ff4a923cf6a9b2b0f0808f4585643a2ec0"
    sha256 cellar: :any,                 sonoma:        "88912743304f2a42ecc6d32a1a893596105f379c7c7bb29693c5c1d1beffe368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dff4c442ccddd4106cf37b90df3919361f2e452bc0e1092187bd10c8f1de42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0ec2558210fb1e81614db1a25319a8bdc6ff2dd3d91dc775bfc1636b462cfe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libgsf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
