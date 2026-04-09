class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/refs/tags/v12.13.0.tar.gz"
  sha256 "4a360c815f5a8bdcae6db184860788696bb1c63d6999cc676e47690fc8b659e5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e4af909ecd68850af6c7bb8718c06f9e4dc48fbf2a7021cec0ef576d97ed1d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e4af909ecd68850af6c7bb8718c06f9e4dc48fbf2a7021cec0ef576d97ed1d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e4af909ecd68850af6c7bb8718c06f9e4dc48fbf2a7021cec0ef576d97ed1d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "56a755a49808c3f74dd663f44a2351bcacfc4d3b136018a919306ab2220814f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10970097c0ed9c5510b90456da34ab992b56ae7a5ce92cd1bf253d872e25461e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cfe4f159486a5ad26348f9c70b190d33252d91ae315e2a98e486c60aae8602d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    input = "GET https://example.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match "Requests      [total, rate, throughput]", report
  end
end
