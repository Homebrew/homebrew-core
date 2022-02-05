class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.9.tar.gz"
  sha256 "1c0feca8db4d05cf8c29c39c0470cff75cc5fe18b17f5fa260bd9aa7c58ce986"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c77d571d6fbcc4b8c15f6d7ac3fd93d6d7e4609cb5d8b85215857d75a870e13d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c77d571d6fbcc4b8c15f6d7ac3fd93d6d7e4609cb5d8b85215857d75a870e13d"
    sha256 cellar: :any_skip_relocation, monterey:       "8e0c2eb820f7d8bae63156f3109a4d34205f51a158ec4a71348caed3b6c6b6e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e0c2eb820f7d8bae63156f3109a4d34205f51a158ec4a71348caed3b6c6b6e6"
    sha256 cellar: :any_skip_relocation, catalina:       "8e0c2eb820f7d8bae63156f3109a4d34205f51a158ec4a71348caed3b6c6b6e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e600b95c31dd6811a2a3265607bfa2098ff43f57489b0820a088203f989e9e0"
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
