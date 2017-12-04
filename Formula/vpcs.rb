class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "https://vpcs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vpcs/0.8/vpcs-0.8-src.tbz"
  sha256 "dca602d0571ba852c916632c4c0060aa9557dd744059c0f7368860cfa8b3c993"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac52b231d875679e7bd4da3a09c6b5bc833e5b93fe5a77749dc834b1d82d21d5" => :high_sierra
    sha256 "78c7e415e9bcbdf28cfdda5d37fce9cc7d735b01d61400b41239e0cdee17ada5" => :sierra
    sha256 "0f1a65e672fd1d2dbc866279835231ec3737e64c514f38a08bf409807e910222" => :el_capitan
  end

  def install
    cd "src" do
      system "make", "-f", "Makefile.osx"
      bin.install "vpcs"
    end
  end

  test do
    system "#{bin}/vpcs", "--version"
  end
end
