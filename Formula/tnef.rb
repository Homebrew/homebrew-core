class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.17.tar.gz"
  sha256 "1dd87ebc0ff32c60ce2bc87362b880dc885525051bf3da55e11492565831c6da"

  bottle do
    cellar :any_skip_relocation
    sha256 "80c433d6b842003d3f1ba5644b86299f92f5699af96715550bdc167272edaa76" => :catalina
    sha256 "5ba739818e3a1d567b41b55d7f91b0cba091d72cae8163c81a4ce28580b362a8" => :mojave
    sha256 "15020412f544e13024591117403ff6db1abe840a225d567c755c1f88652fc84d" => :high_sierra
    sha256 "f7364607dc960c4b18ff4643cbbb5ebb89a591c36d71a6c2344ab99b725a6f27" => :sierra
    sha256 "ab8d466c0d78822062f8b5a347cc0f5897e02b7c2754bf18613bad85c911c52b" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tnef", "--version"
  end
end
