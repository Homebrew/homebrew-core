class Tunnel < Formula
  desc "Expose local servers to internet securely"
  homepage "https://labstack.com/docs/tunnel"
  url "https://github.com/labstack/tunnel-client/archive/v0.2.12.tar.gz"
  sha256 "939ce5a0485c945b8e92eb99a29ae0a12ec46a66e59cef44ad9af2dbe2371163"

  bottle do
    cellar :any_skip_relocation
    sha256 "864e864e9eaa00eafa0444fbe47ae3054a7a44d6fd3d7708c006756cde62ebed" => :mojave
    sha256 "150d674d174be7d81d9dcb339faa45420fc3359625480a1b9e1d6bad3dbbc456" => :high_sierra
    sha256 "19147727e7ccf1755978de68149fc42cb0b8b6e05f2d6e82ec83f7a9e045707e" => :sierra
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
        exec bin/"tunnel", "8080"
      end
      sleep 5
      assert_match "labstack.me", (testpath/"out").read
    ensure
      Process.kill("HUP", pid)
    end
  end
end
