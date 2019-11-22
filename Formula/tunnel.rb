class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.13.tar.gz"
  sha256 "7b70b4728f90811c9bee7523af52458015bac65e22c6cee5be66122711bd1451"

  bottle do
    cellar :any_skip_relocation
    sha256 "a14638ad3dc0274cd139b35e4dcccd430377df523de210dd65f8c675a7c6bbf2" => :catalina
    sha256 "c6904decdc80d8933e30be948c454d9c499ec2cf64fc288cb31939e9c638c141" => :mojave
    sha256 "fc7f9056d7f67ddcdec8321e072861004711e5ee5b2b031332bfc13929068b55" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "ping"
  end
end
