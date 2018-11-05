class Tunnel < Formula
  desc "Expose local servers to internet securely"
  homepage "https://labstack.com/docs/tunnel"
  url "https://github.com/labstack/tunnel-client/archive/0.2.11.tar.gz"
  sha256 "5e31e993a858dffb5c900188a6010336d664f5ad41fbab309c6463f2fb97b706"

  bottle do
    cellar :any_skip_relocation
    sha256 "223066c6e478837e81e1b172315da97f8933d084403b3eedabdbebbfe1d0d2b4" => :mojave
    sha256 "7d954ad417f39b191ef009a6a7dd99bbde05b6ae8076d2d882be481bd069e8b3" => :high_sierra
    sha256 "5215c4b688c6d8524160609fdf3eeeba2536520249b51b5dbe36aba9758957a5" => :sierra
    sha256 "81165ab0daeabc225983901f916244ed49b3b77bce4a213d876f41cd3a173b61" => :el_capitan
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
