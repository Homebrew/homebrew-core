class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.3.3.tar.gz"
  sha256 "731997a4b884e2cb5dc1ea2c13fb219dd02dbf45f92b67f78be7047c549e9179"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3855e7a67cb6e291c31e914af7b448a32ecd5a34e8453dfc91f8d2cd5bafb63" => :mojave
    sha256 "869409fb0ecbfde5891f1da0d520dd238696a62c7ee7cf42dcc534c03250afd8" => :high_sierra
    sha256 "d99a3e501d44eb0139752b193eb1e3d0b02b9e708fe183a76f0fdffc107f155d" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "start", "8080"
    system bin/"tunnel", "kill"
    assert_predicate testpath/".tunnel/daemon.log", :exist?
  end
end
