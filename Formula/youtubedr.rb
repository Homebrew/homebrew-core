class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.18.tar.gz"
  sha256 "d87fc03455b5b3c1dde4ca2b119c33279e3b4dae92fc2d161e64b04152619ac3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6383f14e891c8bcd3f0a0bbc24747912a782af05dc5d8d6cbc711dded47d981f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6383f14e891c8bcd3f0a0bbc24747912a782af05dc5d8d6cbc711dded47d981f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6383f14e891c8bcd3f0a0bbc24747912a782af05dc5d8d6cbc711dded47d981f"
    sha256 cellar: :any_skip_relocation, monterey:       "891591222ac8c125695682a8e04535bfb507b6e747e127c8383effabbfe08dd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "891591222ac8c125695682a8e04535bfb507b6e747e127c8383effabbfe08dd0"
    sha256 cellar: :any_skip_relocation, catalina:       "891591222ac8c125695682a8e04535bfb507b6e747e127c8383effabbfe08dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7719a1cd17abb6f118ef22285ceafc05c2bb26ea7ff0e10af86403fe54922a61"
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
