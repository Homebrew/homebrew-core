class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.27/QuantLib-1.27.tar.gz"
  sha256 "5c2cab0f9bbcdcd3ca1b45d7930b3ab7e120857587b6f61c463b2a012a8bc6a7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9469c237a3adca0188eeb7a75ae4c4c9556efb7c59b1b938cca1dafd7b8cae29"
    sha256 cellar: :any,                 arm64_big_sur:  "6ca4fa3994e3f0bd6d15fa8d3cd1410fd325aca48f494861714842f2251c935c"
    sha256 cellar: :any,                 monterey:       "19a554fcd363682a9e4f68a9e1eecd749af0b64c2f311bddd5063d47bb21915f"
    sha256 cellar: :any,                 big_sur:        "01719b2a67dfc2d5f471c037117db2792d006d9b50d5bdae7d7bc9f110476deb"
    sha256 cellar: :any,                 catalina:       "082b92568410b8199bc2d24a84a70424f193290c68d63a0b0c181a0c952aca03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eacc5e640534e0f583cff1f444e51ac7bf92223dfb4a0b259182fa4f72fdc46"
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
