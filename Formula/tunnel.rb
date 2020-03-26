class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.14.tar.gz"
  sha256 "83f7d63520171f052ff50d2e3f56675545350b0aa812b3634397c8d6916292fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ebbd50a674366bb3dc57632b5aa9a95886cf13ef69a1ecdcb2f9074bb4c6ada" => :catalina
    sha256 "02b1728c7b8f973e0bec3dea0944f591e00c511179cc1c50f2483833c83d94cd" => :mojave
    sha256 "94fe0f4a2841c10c8f1031cd9083d0c683b52ed8f94c8d657eefc2de76e7c5c2" => :high_sierra
  end

  depends_on "go@1.13" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "ping"
  end
end
