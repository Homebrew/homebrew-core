class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.9.tar.gz"
  sha256 "e05c0d1ca16f2339397f922fa6245993db82a4e95487ee75049cdc6fbb540b7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8d3bfe18878fe53182e5714a94f532751b55a2490af377a58b63f6da1db9f11" => :catalina
    sha256 "3992ffbaaf96025d8bc6a1f66c0825be481f10e2ed7e90838056e8c4db3ff063" => :mojave
    sha256 "d1e794bb4c5144b1bb017ecef3de53e7cfb36fa9ceff856ef54c14f3e7bd6ed4" => :high_sierra
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
