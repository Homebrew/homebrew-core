class StreamStats < Formula
  desc "Output statistics about data from stdin while redirecting the data to stdout"
  homepage "https://github.com/ddrscott/stream_stats"
  url "https://github.com/ddrscott/stream_stats/archive/v0.1.0.zip"
  sha256 "9ed73d43e932bd46adbfbf2c0fd15f2a761f28dd85837db8da1015661f9de180"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/stream_stats"
  end

  test do
    system "head -100 /dev/random | #{bin/"stream_stats"} > /dev/null"
  end
end
