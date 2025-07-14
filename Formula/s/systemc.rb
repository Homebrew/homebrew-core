class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://systemc.org/overview/systemc/"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/3.0.1.tar.gz"
  sha256 "d07765d0d2ffd6c01767880d0c6aaf53cd9487975f898c593ffffd713258fcbb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b2580caeadfaaa3e0dee957d949e24e1a7efea6d2e08a5ac5a944ed940af119f"
    sha256 cellar: :any,                 arm64_sonoma:  "3caf64beca918351c3def6491f3f44ab6d6e30944256598042c06e27f4c3f69d"
    sha256 cellar: :any,                 arm64_ventura: "2a53ee4fc148a6cff3e4dd3bc9fb90ead7473bea18330d1165df302eff50ca42"
    sha256 cellar: :any,                 sonoma:        "2f71a7bdcf98225af604842ac634e8b6f6e5b6e04f88c220a870832620c67332"
    sha256 cellar: :any,                 ventura:       "36d4a60c1bf2ed3f6af253cf8c7691c1bcf6d4c544a1eed52e1978bcc94f1808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "323a1432c8de12dbab0de9552daf0ed9f399ba98cb708118e6aafd0493b50531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38bc41a193499a5d8487437cd0aa90ada0456938807ed8b091564ca301606b00"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build

  # Workaround "No rule to make target 'DEVELOPMENT.md', needed by 'all-am'":
  # Ref: https://forums.accellera.org/topic/8068-no-rule-to-make-target-developmentmd-needed-by-all-am/
  patch do
    url "https://sources.debian.org/data/main/s/systemc/3.0.1-1/debian/patches/doc-targets.patch"
    sha256 "3c4c79453599fed2a0082b9564e6a2dd845615afcc173d0e235933b2d2b18bf4"
  end

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-unix-layout", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    CPP
    system ENV.cxx, "-std=gnu++17", "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
