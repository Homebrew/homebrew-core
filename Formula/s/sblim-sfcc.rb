class SblimSfcc < Formula
  desc "Project to enhance the manageability of GNU/Linux system"
  homepage "https://sourceforge.net/projects/sblim/"
  url "https://downloads.sourceforge.net/project/sblim/sblim-sfcc/sblim-sfcc-2.2.8.tar.bz2"
  sha256 "1b8f187583bc6c6b0a63aae0165ca37892a2a3bd4bb0682cd76b56268b42c3d6"
  license "EPL-1.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sblim-sfcc[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "91850d84d41509e73588a88dcc741a3ab9367c6e84c366689340cd9b66d00bf6"
    sha256 cellar: :any,                 arm64_sequoia:  "6f074cbf8dda6d4bcf92790a16addbdb0ee1d0d965574113544580e559515a5b"
    sha256 cellar: :any,                 arm64_sonoma:   "d16153e6113f4157639b35994c6c49b302a6583e6c092b252aafa3a3255289a5"
    sha256 cellar: :any,                 arm64_ventura:  "c8b172932d29f6725a2b1a87945ae3d5f904fd04ae045b3599e86eeb8bd103b3"
    sha256 cellar: :any,                 arm64_monterey: "0cc8c1e52119cd38c9c9e6f2b08f0083693ae35ab2d40aa8c6352ec21c60909e"
    sha256 cellar: :any,                 arm64_big_sur:  "eb4bb2cbbb7ef660b04d031f3634a29f2c4c9b4a4c0259bffe4cbdf87a8efbf5"
    sha256 cellar: :any,                 sonoma:         "03982c814ee052c41459385167fb7e112c021f01d73cf9e8b370e650ecc946a5"
    sha256 cellar: :any,                 ventura:        "35d98d6f07a235f4aa7e8b2dbbde54370bbb11143bf1bb4c06f326b624b74ccc"
    sha256 cellar: :any,                 monterey:       "368b654d4d5deee68646887d8946c78a5e3d7f7dc9022669cc8395f64361a8f0"
    sha256 cellar: :any,                 big_sur:        "ab534857fa92d53f614c51b5a23f51986936c7d4156774f6f137c1ecabde2818"
    sha256 cellar: :any,                 catalina:       "65ac52dfd7703bc7bb36d61a8458deb2b3efcbbcd9ebac2298d31bae8203ed2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5fd23513981b7f2f47c9f8ce8b0d0fd352cb954045f49d060ffd6f581dc715ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c029309cfad2b173fe5b26e004b07b94fd295076a88244f3dbc2030c38a47e0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    if DevelopmentTools.clang_build_version >= 1500
      # Work around "backend/cimxml/grammar.c:305:9: error: call to undeclared function 'guessType'"
      # Ref: https://sourceforge.net/p/sblim/bugs/2767/
      ENV.append_to_cflags "-Wno-implicit-function-declaration"
      # Work around "ld: unknown file type in '.../cimc/libcimcclient.Versions'"
      ENV.append "LDFLAGS", "-Wl,-ld_classic"
    end

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cimc/cimc.h>
      int main()
      {
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcimcclient", "-o", "test"
    system "./test"
  end
end
