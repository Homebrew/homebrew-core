class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.13.tar.gz"
  sha256 "bb52df179781f9c19ef8e976780c4798b0cdc4d21fa72a7a386016e24d1a86e6"

  bottle do
    cellar :any
    sha256 "bcbc64fa5e09c72d83e13c660b2e2db3ef538c0f0f130e74d7b8f550e1c17658" => :mojave
    sha256 "f1b352fbdcc03553ba7fa6309ca47ece5fd7c47063b12216fa523430a20010bb" => :high_sierra
    sha256 "48fa29a16624ead3044322df0cb295420ba88fb61471736bc6c2efe44a87b357" => :sierra
    sha256 "274c1574aed3d3b1cb286c2edf788ac40d4d266a42e99b6f9988697600cd7b29" => :el_capitan
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
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
