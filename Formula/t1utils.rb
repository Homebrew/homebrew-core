class T1utils < Formula
  desc "Command-line tools for dealing with Type 1 fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/t1utils-1.41.tar.gz"
  sha256 "fc5edd7e829902b3b685886382fed690d533681c0ab218a387c9e47606623427"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5e14909396bd86e81c3c33f2c6607d27dadc341b47b801c7962341edeaa360c" => :sierra
    sha256 "ef1614e19de70eb93062028225d31638af49bedb776555115a4700a55376c091" => :el_capitan
    sha256 "649df18b4370c27296864ac5566a5d97d4e4f3f124b2ce1daafc5ea5ec7df2d6" => :yosemite
  end

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
