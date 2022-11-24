class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.18.tar.gz"
  sha256 "d87fc03455b5b3c1dde4ca2b119c33279e3b4dae92fc2d161e64b04152619ac3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c954d5d7093b8b2d31e38ec6124e74871a47346c0d813afadf036a46f0bbfa1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c954d5d7093b8b2d31e38ec6124e74871a47346c0d813afadf036a46f0bbfa1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c954d5d7093b8b2d31e38ec6124e74871a47346c0d813afadf036a46f0bbfa1f"
    sha256 cellar: :any_skip_relocation, monterey:       "62a051a3cc2211b15006dc5311ceaad1a5c2c320a5116702a21f6f1b0a10f1a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "62a051a3cc2211b15006dc5311ceaad1a5c2c320a5116702a21f6f1b0a10f1a1"
    sha256 cellar: :any_skip_relocation, catalina:       "62a051a3cc2211b15006dc5311ceaad1a5c2c320a5116702a21f6f1b0a10f1a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae317c60a48d6cd8d54c0e51a55918b5b4154322eb3618f215dc0fa59b0690f5"
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

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch\?v\=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
