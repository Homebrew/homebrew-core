class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.15.tar.gz"
  sha256 "093246256d8f0ef719cb1bd5a5548b56031b686c553f44f84236bd62b0519357"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2e2f0ad2385e3aaabeacec3ca5d6aaa4daaac4aa05206c95fa1baf7566aa8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e2e2f0ad2385e3aaabeacec3ca5d6aaa4daaac4aa05206c95fa1baf7566aa8e"
    sha256 cellar: :any_skip_relocation, monterey:       "11f9686eb0a0bcc63c0c3bfbf3e0516e08ede934757c9dfc8ee554261b5e72d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "11f9686eb0a0bcc63c0c3bfbf3e0516e08ede934757c9dfc8ee554261b5e72d1"
    sha256 cellar: :any_skip_relocation, catalina:       "11f9686eb0a0bcc63c0c3bfbf3e0516e08ede934757c9dfc8ee554261b5e72d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb2b26fe97e737dd0a9d7386beb8d5825df15a229f600a3cc7ae09786ce0f03"
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
