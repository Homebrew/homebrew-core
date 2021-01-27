class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.30.10.tar.bz2"
  sha256 "affa80deec78921f86335e6fc3f18b80aefecf424f6a5755e9f2fa0eb0710edf"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "c53043a419c1409b8c1df9a3ab3b304525a69392933ffd421fa6fa3c22df4ab9" => :big_sur
    sha256 "e5b28b3af541976f1bb6a3e5642ae7cc51ee82d0be992d28a0f533417f0afb69" => :arm64_big_sur
    sha256 "6ab4aae5b944f5fdcbd08d54b9fa55275e5a4cea89e1711b1288353ec75f6f4b" => :catalina
    sha256 "c579e8246255757af42717d1b93989c6422e8fba8459e5446963ab95bd78f383" => :mojave
  end

  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    pipe_output("serdi -", "() a <http://example.org/List> .", 0)
  end
end
