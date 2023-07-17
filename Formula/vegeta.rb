class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v12.10.0.tar.gz"
  sha256 "4ea951258d041887a2cbdd0b87bf87023c304033d804eca1bfa0a1091b3124c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a91335ced6e3c9928784857f28b00758ca799573492268367747b7f88a300d5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a91335ced6e3c9928784857f28b00758ca799573492268367747b7f88a300d5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a91335ced6e3c9928784857f28b00758ca799573492268367747b7f88a300d5f"
    sha256 cellar: :any_skip_relocation, ventura:        "7e5611b47ea3e72ab5f655a2a558d8c0158cfa1c932d5fe8649e5d299a9ee8b0"
    sha256 cellar: :any_skip_relocation, monterey:       "7e5611b47ea3e72ab5f655a2a558d8c0158cfa1c932d5fe8649e5d299a9ee8b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e5611b47ea3e72ab5f655a2a558d8c0158cfa1c932d5fe8649e5d299a9ee8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3061e67b6f3c862ddcf3482312b3aae895760d0de48435110e392058d374d61c"
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
