class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.15.tar.gz"
  sha256 "093246256d8f0ef719cb1bd5a5548b56031b686c553f44f84236bd62b0519357"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa869be01efa3d0ae8300b1704700cc65904438784e112941c7dfc0529cf837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eaa869be01efa3d0ae8300b1704700cc65904438784e112941c7dfc0529cf837"
    sha256 cellar: :any_skip_relocation, monterey:       "95b83c67af793112b1f18197971a1a4cfcfbb3056bab45a7c07c91c2947eb1b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "95b83c67af793112b1f18197971a1a4cfcfbb3056bab45a7c07c91c2947eb1b2"
    sha256 cellar: :any_skip_relocation, catalina:       "95b83c67af793112b1f18197971a1a4cfcfbb3056bab45a7c07c91c2947eb1b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "790dda94568b605b0c3464dbd0c7ee98c0fbe7d9d7603d7a6f801f974ada52a4"
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
