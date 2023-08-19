class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v12.11.0.tar.gz"
  sha256 "5167a71c956e5fb022a173534adbee07fdfc08476802e2d855b8c13fe3276ce6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82ac7506d20abcd23c523ce9aa9049c2662525757e25cb83ffbb62f038d7f919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82ac7506d20abcd23c523ce9aa9049c2662525757e25cb83ffbb62f038d7f919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82ac7506d20abcd23c523ce9aa9049c2662525757e25cb83ffbb62f038d7f919"
    sha256 cellar: :any_skip_relocation, ventura:        "232c955dac504ba052e8129f25aa33b4f0fb6a4b0b4aef4c8c1c2055dc735d69"
    sha256 cellar: :any_skip_relocation, monterey:       "232c955dac504ba052e8129f25aa33b4f0fb6a4b0b4aef4c8c1c2055dc735d69"
    sha256 cellar: :any_skip_relocation, big_sur:        "232c955dac504ba052e8129f25aa33b4f0fb6a4b0b4aef4c8c1c2055dc735d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aac6cd43c69bc13f5fba3aef9f94a2a3ff96485ab163144f4265b260d99506ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    input = "GET https://example.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
