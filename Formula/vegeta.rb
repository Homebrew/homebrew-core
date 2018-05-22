class Vegeta < Formula
  desc "HTTP load testing tool and library. It's over 9000!"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/releases/download/v7.0.0/vegeta-7.0.0-darwin-amd64.tar.gz"
  sha256 "e0e9250cf60f350cb4e997791cfd7404a590ad41667144bbdcc0b94f157f8b79"

  bottle :unneeded

  def install
    bin.install "vegeta"
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
