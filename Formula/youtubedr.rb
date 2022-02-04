class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.8.tar.gz"
  sha256 "25a390123af7beb4d5b6b004cc3c3c26fd2cd6fd7b8fb2dc7449284725399429"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aaa7c33fc0fc9afe8f00611ac7c73f886498d392c20978604d19e3b8aa13f38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aaa7c33fc0fc9afe8f00611ac7c73f886498d392c20978604d19e3b8aa13f38"
    sha256 cellar: :any_skip_relocation, monterey:       "34b9f7f6aef9b2da4d7913ce554eae80f9c5a46e0ba07d9ce8f9a6109ab76493"
    sha256 cellar: :any_skip_relocation, big_sur:        "34b9f7f6aef9b2da4d7913ce554eae80f9c5a46e0ba07d9ce8f9a6109ab76493"
    sha256 cellar: :any_skip_relocation, catalina:       "34b9f7f6aef9b2da4d7913ce554eae80f9c5a46e0ba07d9ce8f9a6109ab76493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e2773effd74326fca3af75b8ee06fe7df6ca10ee8b5ad2fcb48fc63bf7adb7"
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
