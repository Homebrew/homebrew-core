class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.34/QuantLib-1.34.tar.gz"
  sha256 "eb87aa8ced76550361771e167eba26aace018074ec370f7af49a01aa56b2fe50"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "41d28e8d1b0efabbf573aeea930875b762e2e4b386a0c6b7b6502dd75b6c40fe"
    sha256 cellar: :any,                 arm64_ventura:  "8c170b6ac2f5af5f62222b3b6368d9275f64412a4183716cfd35648a41bf3c69"
    sha256 cellar: :any,                 arm64_monterey: "a8c74793924d0e9a69b70b3350e92fe1194b58ddd28033d5c5ee8aa27f0b3dcc"
    sha256 cellar: :any,                 sonoma:         "d77cc110e0466412d5ecdd22c0ea84dc754755fc95b57b45b736cfeb87f3cf5b"
    sha256 cellar: :any,                 ventura:        "2ea014a7f8b64f73c9fdeaea0a9bdb6a0caea410e7490ace7672d380854d261c"
    sha256 cellar: :any,                 monterey:       "e0660fb1575af5c75fbfda66cf8a7f2297bad4b53cdcefa6f7b95d3c7d577314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d62c8056319087ca1af3403d256a30c13b7d6f81eb432b9cdf08a45786377da4"
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
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
