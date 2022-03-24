class Wv2 < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/wvware/wv2-0.4.2.tar.bz2"
  sha256 "9f2b6d3910cb0e29c9ff432f935a594ceec0101bca46ba2fc251aff251ee38dc"

  livecheck do
    url :stable
    regex(%r{url=.*?/wv2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e757d5cf4bd8db93cd2b4383b38c748ea78f0f301d1740aa661ec35ee9e9ea1d"
    sha256 cellar: :any,                 big_sur:       "097b7d4e10b4ef00d8298ef897acb9baa3c9b84aa0b7416e4e561700e8ab408b"
    sha256 cellar: :any,                 catalina:      "944451190aa61c6ea3dd74fffbc9e92e999b8eeb559a46f4c4708d5f9b4f154f"
    sha256 cellar: :any,                 mojave:        "7bda8de476777410ab350ceca0e089e20169f17a3d9cb31d313653c906766a85"
    sha256 cellar: :any,                 high_sierra:   "35120de253c5dcfd6da711f7529bd8e4a0ffd45eed540057ef57d1a9d2ab0091"
    sha256 cellar: :any,                 sierra:        "cd0856f53f0a143f5b0ea7dd61a0d23613db6de84538fa222e2819217a3ed3af"
    sha256 cellar: :any,                 el_capitan:    "b3a07e873f69b90ed83d47ccedb6bc5fefcb5dc5c9ffd1ecfd38c03dd094afea"
    sha256 cellar: :any,                 yosemite:      "51ea82d6630ceee1739d0f252462ef8c4394ffaf0fb81b0a5141990f865f1427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bd22b4bd66ddf417a1ee0882ca0dfc3b4bcb218d50e890a28a1752d5e4c546b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"

  uses_from_macos "libxml2"

  def install
    ENV.append "LDFLAGS", "-lgobject-2.0" # work around broken detection
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    ENV.append "CXXFLAGS", "-I#{Formula["libxml2"].include}/libxml2" unless OS.mac?
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (share/"test").install "tests/testole.doc"
  end

  test do
    cp share/"test/testole.doc", testpath

    (testpath/"test.cpp").write <<~EOS
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
    EOS

    wv2_flags = shell_output("wv2-config --cflags --libs").chomp.split
    system ENV.cxx, "test.cpp", "-L#{Formula["libgsf"].lib}",
           "-L#{Formula["glib"].lib}", *wv2_flags, "-o", "test"
    assert_match "Done", shell_output("#{testpath}/test 2>&1 testole.doc")
  end
end
