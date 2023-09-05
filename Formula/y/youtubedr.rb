class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "48efe037d9a599471439f43faa1e83a17c6c0a4afff10864f2451220c1631181"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4c2d628f6c22daad8c9076c5d3439d86e946287df0f500c0662f311bad0820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac4c2d628f6c22daad8c9076c5d3439d86e946287df0f500c0662f311bad0820"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac4c2d628f6c22daad8c9076c5d3439d86e946287df0f500c0662f311bad0820"
    sha256 cellar: :any_skip_relocation, ventura:        "582b7de2e5212c139d5622c194e155cce62650e3cb2f2d88f069191c56e91d7a"
    sha256 cellar: :any_skip_relocation, monterey:       "582b7de2e5212c139d5622c194e155cce62650e3cb2f2d88f069191c56e91d7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "582b7de2e5212c139d5622c194e155cce62650e3cb2f2d88f069191c56e91d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "463238bd4b5386f20003714a5108709ff67ba890e6cc6969521ff24b30a5f6ac"
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
