class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.8.1/QuantLib-1.8.1.tar.gz"
  sha256 "27d14d5e49b8a21d20f03da69a05584af50e6a3dbe47dad5b9f2c61ad3460bed"

  bottle do
    cellar :any
    sha256 "62bdbb6d934d1667220508de6f0738965dae8ce8dca2c34f48df626e40be4224" => :el_capitan
    sha256 "137f974e28a129b0a16665833439be4ab7db443d9389a9a9856e6fd58fafe0d3" => :yosemite
    sha256 "77283b2405461fe36439dad406c7849b42d0927fb27a1e490d57bbf631584b63" => :mavericks
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
