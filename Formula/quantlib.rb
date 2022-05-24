class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.26/QuantLib-1.26.tar.gz"
  sha256 "04fe6cc1a3eb7776020093f550d4da89062586cc15d73e92babdf4505e3673e9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ddeb386e7eb27aab8f00620125603599dd3371039ad911a6e0196c1ffaba809"
    sha256 cellar: :any,                 arm64_big_sur:  "cfce6241b00cc27687f707239e799d8d3d1cc8867cabfcd19170dea66c82020c"
    sha256 cellar: :any,                 monterey:       "ed88f2b4b58d73bc14a509d387a9c5f78949f29dc82438a240d35b2fee800bd5"
    sha256 cellar: :any,                 big_sur:        "abbf1c1ae1dd97370d5368bc59e18ec2ef85217c7d75a073326558111d665f29"
    sha256 cellar: :any,                 catalina:       "a2d53f05e70f1ee733ae7d7f6617c00bd8fd032a725c8ab02dc87581864352fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08314adef6c54e10a7fb4eee7c38f811791a055a4cf90241208a802db7fbba6"
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    ENV.cxx11
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
