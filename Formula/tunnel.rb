class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.3.0.tar.gz"
  sha256 "7488a90395239232ab2702e42f3be614277087ececcfda27b63eba73ed62d4de"

  bottle do
    cellar :any_skip_relocation
    sha256 "57a9c7581653336740728f5d9d75e6292f941844ba14c2b2e48060e8d52aad4e" => :mojave
    sha256 "61e5d30fad5d2011f0bbe8eb9301565d0df9056b4a5dce65acbd5f88e6ba747f" => :high_sierra
    sha256 "b5cf0fb1637e8d1342bf6a15e6bffe21e2a4d20f157401bafa36f596e8106aba" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    begin
      pid = fork do
        $stdout.reopen("#{testpath}/out", "w")
        exec bin/"tunnel", "start", "8080"
      end
      sleep 5
      assert_match "labstack.me", (testpath/"out").read
    ensure
      Process.kill("HUP", pid)
    end
  end
end
