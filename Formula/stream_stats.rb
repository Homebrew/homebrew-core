class StreamStats < Formula
  desc "Stdin throughput statistics"
  homepage "https://github.com/ddrscott/stream_stats"
  url "https://github.com/ddrscott/stream_stats/archive/v0.1.0.tar.gz"
  sha256 "5df10e79754c877b379f89ad1d244df21359e2b5b1d9cd33b11c865a1d29f61c"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/stream_stats"
  end

  test do
    system "head -100 /dev/random | #{bin/"stream_stats"} > /dev/null"
  end
end
