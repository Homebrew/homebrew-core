class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.5.tar.gz"
  sha256 "802537484d4247706f31c121df78b29fc2f26126995963102e19ef378f3c39d2"

  bottle do
    cellar :any
    sha256 "fc6c551c54b78b477836368f8f4c24f39bc8324ced4aaed418ed6ebde071c130" => :catalina
    sha256 "ad3ae23deb4f16249fbfc8794a30116911a211c76adbc024948cf9b8842a55b4" => :mojave
    sha256 "870f730cc4ee76700749f4091d111cb0e9a529d43c1ba7cb40b36807e49d9b76" => :high_sierra
    sha256 "794e2e265413005b3c26a0fa38e1ab8957bd1ec13cf4abb63730070181d9beb4" => :sierra
    sha256 "292447a86953bb10361130542d2db9e0c0fc410e9be3b13b8c80891fbfaeec20" => :el_capitan
    sha256 "6f769c30797af9cb98bf02491706f96b7085eed2d5d05c377e51ca5e0bf8541a" => :yosemite
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
