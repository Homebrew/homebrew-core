class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.13.tar.gz"
  sha256 "082a6df600d390817ea3765196f5f5ca11a41ab81bfd591cb83a523acd011025"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef95c2836b3fb007cfb4ec7145e0755499c8625e2907c639ef807756231d2e8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef95c2836b3fb007cfb4ec7145e0755499c8625e2907c639ef807756231d2e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "0b16f6015eb65f1318bf3bf1edc8f12a922a273971b4f1b31927392a38f4db87"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b16f6015eb65f1318bf3bf1edc8f12a922a273971b4f1b31927392a38f4db87"
    sha256 cellar: :any_skip_relocation, catalina:       "0b16f6015eb65f1318bf3bf1edc8f12a922a273971b4f1b31927392a38f4db87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a9f86e792764aed25ed76564dfd9832982f6b6967ad5c5a1ab7bdc43848ecc"
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
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch\?v\=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
