class SpeedtestGo < Formula
  desc "CLI and Go API to Test Internet Speed using speedtest.net"
  homepage "https://github.com/showwin/speedtest-go"
  url "https://github.com/showwin/speedtest-go/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "48d01137468da9d419a3940a652803dafd8a6820abcd985b85c9d0c86b417ba3"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c30480c4f4f69864564dd7b1ffed55c8f95fc8db6c14b4dca9d8ac0866d1486"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c460180f156e1e70209edc76a39348297fc69452767167a8d39623305ece5703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c460180f156e1e70209edc76a39348297fc69452767167a8d39623305ece5703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c460180f156e1e70209edc76a39348297fc69452767167a8d39623305ece5703"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c44d2c556d2ee1e5a06a852b315d70505f48367d659f35bc3959036e61ea1b05"
    sha256 cellar: :any,                 x86_64_linux:      "c791f67a07932b13b1f974248fd2136cb0ecde7258bca39eb7efa346f25dbf28"
  end

  depends_on "go" => :build

  conflicts_with "speedtest-cli", because: "both install `speedtest` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"speedtest")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/speedtest --version 2>&1")

    assert_match "Available city labels", shell_output("#{bin}/speedtest --city-list").to_s
  end
end
