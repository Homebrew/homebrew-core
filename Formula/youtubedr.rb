class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.3.tar.gz"
  sha256 "bf52689b603dbf86e702ed867bece8e4b067cfcafaa3bd04a57bf7cfcca90246"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb9c432ff75ff208c5f7ab51498c0b7ae31fc45799be08445615af46ee21e67b"
    sha256 cellar: :any_skip_relocation, big_sur:       "480c6f9b88c445c06bd11d893ef166aac2dd872b9940ffdd377d3d11f37a2570"
    sha256 cellar: :any_skip_relocation, catalina:      "480c6f9b88c445c06bd11d893ef166aac2dd872b9940ffdd377d3d11f37a2570"
    sha256 cellar: :any_skip_relocation, mojave:        "480c6f9b88c445c06bd11d893ef166aac2dd872b9940ffdd377d3d11f37a2570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b65c32cafe012c0ec3abfc8c51ab0d4a4fdb268d3d9fef0c20f244e8e0e33db"
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
