class T1utils < Formula
  desc "Command-line tools for dealing with Type 1 fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/t1utils-1.41.tar.gz"
  sha256 "fc5edd7e829902b3b685886382fed690d533681c0ab218a387c9e47606623427"

  bottle do
    cellar :any_skip_relocation
    sha256 "12394b2c7273a3f1d4b7de7fea1a67e84cb2c0e3113c462108aa1491b22ccccd" => :catalina
    sha256 "e597bc84951ac4148dbd0c81747403f3e8d2a52709d9c5bf018f7d7d4fc43cdb" => :mojave
    sha256 "03aaed34570454b58242053b8e6531e78ba036e4a906abaaf29b7b0c48fb008e" => :high_sierra
    sha256 "40e108fcb6088b1c4d1fc1061de851efe3fb826d7353c21d8862216ef8857cd2" => :sierra
    sha256 "fc81594a73833517058d954a208275328ac7e90867ca6b3ca8d4a4553aa34be4" => :el_capitan
    sha256 "0983d0a649572d241ba27ae239888f56c3fe108bf00e2ca9faffd2306a44988f" => :yosemite
  end

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
