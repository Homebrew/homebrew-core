class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.14.tar.gz"
  sha256 "83f7d63520171f052ff50d2e3f56675545350b0aa812b3634397c8d6916292fb"

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
