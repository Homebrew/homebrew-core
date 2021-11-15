class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.24/QuantLib-1.24.tar.gz"
  sha256 "ddda3707002b5af3103bf8b9ac250b233bd06de111c0faca031f2931d884b2e7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d7eb5ba677edbbe19268c4dd5b12b9bf6e7c5d2776ccf350e0f73733bf4bdd2"
    sha256 cellar: :any,                 arm64_big_sur:  "4af724f1b39ac9d52d7e485b85733f083eb14bfccd8603822046506ab7956e96"
    sha256 cellar: :any,                 monterey:       "b4e25a60744bceeb2624591c2f4bc396375c74513d0abec1496fee68fd27f685"
    sha256 cellar: :any,                 big_sur:        "3c9fda9693a86afa5fbbc1b08ab3d964b99b6779a038b561358caabb19fd1813"
    sha256 cellar: :any,                 catalina:       "2b742b1d55890ee8dbea13e12f6b2377dfa936c6ebf6a4983992d5546a72f436"
    sha256 cellar: :any,                 mojave:         "3f6426241bdeec35cb2029054b9830301f1bd84037f12e07906d5b7afd0d99a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ab1b70d643ad45ddd67b16d5071e57b08964cfa440abcb426b6f1fb07c5601"
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
