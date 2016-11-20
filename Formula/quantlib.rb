class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.9/QuantLib-1.9.tar.gz"
  sha256 "eb4aeebaa2b850c36eb8a03bc0c71556f34811913b4bea21ec0553a91b746de5"

  bottle do
    cellar :any
    sha256 "b14aff340ff300b7f53b6b190aa60ad595601588866c5c608456233669f27a5b" => :sierra
    sha256 "b32b4708bcdc4240c488151d4b3ccbd6161f82f38619c78dd972e098f4b1ff54" => :el_capitan
    sha256 "7acc9e5a40bda06dadf93fe80694479c4af6cfd01f34acb699241fed846bc81a" => :yosemite
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
