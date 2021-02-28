class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.5.0.tar.gz"
  sha256 "7d54bcd7de413b9ba7b0b98a33b05c5fb003a058fd9469c67657f49a3c5e1a63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35d48c7565c357ccfba86abac56278dfa957601e8a904c0131224a40fd228298"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e3faa7172ab8eb87e2215617a9d1212b5671861a05090c8a815b3ced8a5c0d6"
    sha256 cellar: :any_skip_relocation, catalina:      "260c1b2d84bc38f122c9d4767a42b72e5f75a9de94dcd304ab2ee53bd02c960f"
    sha256 cellar: :any_skip_relocation, mojave:        "9a9f5087f884c4f758bd3a948e4f697a7ce7220e79bfcea14df38eb285c1cace"
  end

  depends_on "go" => :build

  def install
    build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{build_time}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd/youtubedr"
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
