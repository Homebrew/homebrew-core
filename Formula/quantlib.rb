class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.9/QuantLib-1.9.tar.gz"
  sha256 "eb4aeebaa2b850c36eb8a03bc0c71556f34811913b4bea21ec0553a91b746de5"

  bottle do
    cellar :any
    sha256 "8f682c4aad6ec88a2950ae6f7dbbbf4462aec8031661d80a2d4d374b96024f1d" => :sierra
    sha256 "46b39799b60669ddab32f6e0cf08b83af1036ca701837a10e7864b71755841cd" => :el_capitan
    sha256 "bee53cb0776d7b92b2e319c1ab3be2452266beb5c1e5a858a499b0b615ce7e16" => :yosemite
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :cxx11

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}"
      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
