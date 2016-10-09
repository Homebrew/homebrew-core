class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.5.tar.gz"
  sha256 "802537484d4247706f31c121df78b29fc2f26126995963102e19ef378f3c39d2"

  bottle do
    cellar :any
    sha256 "70545acfe2951c5628bbf84f52216c4e69ab6393ba17546201aa94e94bb73fbb" => :sierra
    sha256 "eda3904ee5c70371506cafd793ec9c760f04a57c53db5f6b56fac16a9e67c90e" => :el_capitan
    sha256 "624c5aabfd95a84f62bf8af42837241bcf05bebf16a086697bfb3b097463ad70" => :yosemite
    sha256 "023b4f53216ae74be67387282a813ba56caf15316cd5c9e6c40eff28e3e79a6c" => :mavericks
    sha256 "f3e546d6266e220e80031a9573b3670168098f48730e48ac190dc11700676e31" => :mountain_lion
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
