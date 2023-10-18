class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "f8d60ac8ea16f2fd0e58c12d4502b1b1c5ad46325912cc29fe2031aa897b53a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11f394bda025b75cd4c13ee8346cfc925e4d2f6592d08435b0978b4f749bec90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11f394bda025b75cd4c13ee8346cfc925e4d2f6592d08435b0978b4f749bec90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11f394bda025b75cd4c13ee8346cfc925e4d2f6592d08435b0978b4f749bec90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f394bda025b75cd4c13ee8346cfc925e4d2f6592d08435b0978b4f749bec90"
    sha256 cellar: :any_skip_relocation, sonoma:         "a767486215393900a1d8fb126b39f54526e17aa3f56b62965fb4b2e76f500903"
    sha256 cellar: :any_skip_relocation, ventura:        "a767486215393900a1d8fb126b39f54526e17aa3f56b62965fb4b2e76f500903"
    sha256 cellar: :any_skip_relocation, monterey:       "a767486215393900a1d8fb126b39f54526e17aa3f56b62965fb4b2e76f500903"
    sha256 cellar: :any_skip_relocation, big_sur:        "a767486215393900a1d8fb126b39f54526e17aa3f56b62965fb4b2e76f500903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d72233693a679dec340d1ec3ac307041b8a8505d69601a32ebe3805c7eccbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", "completion")
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
