class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.8.tar.gz"
  sha256 "334819df674f04a38aded32164a7fd8f2fe27063360aa2c55644719f3e1774d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7edab9d63f1978892d1cda9db053aad1ce95278760a3600dd73e5fae1a9ff83" => :catalina
    sha256 "1a885181bfa2fb9ce1be4332bedc584be2770e11f0b680aa5ec16f168561c2a5" => :mojave
    sha256 "033020d1a3c835c56ba1c584faaffd73086b1069054582b94d35209d06df39bc" => :high_sierra
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
