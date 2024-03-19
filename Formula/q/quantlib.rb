class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.33/QuantLib-1.33.tar.gz"
  sha256 "4810d789261eb36423c7d277266a6ee3b28a3c05af1ee0d45544ca2e0e8312bd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "594605a8f4e973252d0f53f6d9d33598efa11ce6d9108323a126266c7d6cbfc0"
    sha256 cellar: :any,                 arm64_ventura:  "a474e677d3a78d5870c705dcd8a5ed0a083c57f3c88e143416a1e33ffaba290b"
    sha256 cellar: :any,                 arm64_monterey: "0c8e0a0755ff1c76ed84981061c307a85448af220daa93397cbc7dea578ebf9e"
    sha256 cellar: :any,                 sonoma:         "d4cdcb6bc4c17bff866923f9b69096de6aba922f44b8c80b9a4481aa02f57c03"
    sha256 cellar: :any,                 ventura:        "a4e70dd5ff438d67dac31b693f9bdb9c119fe97dc76ead78bea797488aea0bc0"
    sha256 cellar: :any,                 monterey:       "30de014fd03ed2404f251a0c67c23ce1924aa40fcd04cfd39e1a077f9e9069e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d4f40dd90fcfd9f708edd19725874580c6dac43a03ec5c60f0929c68a4a555"
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
