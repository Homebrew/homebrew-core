class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.3.1.tar.gz"
  sha256 "de67f55a6374443a5bea20b4da996bb08be79c19628b8bfd4fac79012d0c03cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f1394f3fe82ea97ac661a1bca8aceadb66f58c709f79300eb7851e3e1af9e18" => :mojave
    sha256 "19bb952d82339579c81d7528529c9787b4adea4610361c5dc817652620eefa7f" => :high_sierra
    sha256 "0f51cd9c2a478ae0d692a24921fff0ef6a6392102d145e6a38c8028d27e80788" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    begin
      pid = fork do
        system bin/"tunnel", "start", "8080"
        system bin/"tunnel", "kill"
      end
      sleep 5
      assert_predicate testpath/".tunnel/daemon.log", :exist?
    ensure
      Process.kill("HUP", pid)
    end
  end
end
