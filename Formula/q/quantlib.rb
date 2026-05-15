class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.42.1/QuantLib-1.42.1.tar.gz"
  sha256 "125a1eb5364c87a3d9df386608557bda235b31429bf9fd1e8dce734817e2997f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54fb1f938b6a95edd5927bd4ed7e596a9ea3db9d9d5642b67c068962efd86fb9"
    sha256 cellar: :any,                 arm64_sequoia: "05a993ecbedd10babf8192532f5ab026d73664cb63fa9bbbd04b2aa9f1fdbef5"
    sha256 cellar: :any,                 arm64_sonoma:  "9c8c5da94ebf99bb0335905ee79638c0f1148ff853dffb0bb25b32af8c363c0e"
    sha256 cellar: :any,                 sonoma:        "962ffb7b8842fad8ea438dd977b69261e7750417771f0b07f930d9e0d0462563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75640eebacace4dc327f579e0b8c6889b059dd0b11c8c85d34507e32c5989bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43acc0a86b38fb696cc8a6b0fd7af9cc05ecd536d903bec22a7beec220c49881"
  end

  head do
    url "https://github.com/lballabio/quantlib.git", branch: "master"

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
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
