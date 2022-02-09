class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.10.tar.gz"
  sha256 "04a4f0b745094884fb2902945ac3b1c966fbe4fbd67a027cb482d491662900f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a90989934559d7e9237e35111cd838c1b46b1109618d7b0bc1fcbadde3e4f1ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90989934559d7e9237e35111cd838c1b46b1109618d7b0bc1fcbadde3e4f1ec"
    sha256 cellar: :any_skip_relocation, monterey:       "275cbf2d5a6dabe3e41a3386e77794b0832d4930914fe53a6d83a267889b1168"
    sha256 cellar: :any_skip_relocation, big_sur:        "275cbf2d5a6dabe3e41a3386e77794b0832d4930914fe53a6d83a267889b1168"
    sha256 cellar: :any_skip_relocation, catalina:       "275cbf2d5a6dabe3e41a3386e77794b0832d4930914fe53a6d83a267889b1168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71c76e79c9c7e38a96168abf5aff6a59a904c7e6b75dc9ff6b916477c25462f"
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
