class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.5.0.tar.gz"
  sha256 "7d54bcd7de413b9ba7b0b98a33b05c5fb003a058fd9469c67657f49a3c5e1a63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91af75e110175b1cd364bb1472284dac08670daf115175b7b4cfda4440938769"
    sha256 cellar: :any_skip_relocation, big_sur:       "c11070f97e1d14caabc9bc54cfdc6b64f9fab5be0a8f906c02c6cf1557155014"
    sha256 cellar: :any_skip_relocation, catalina:      "0050fef719b5136394e6a12d35b3deafac78feb5747a90c914972d6a50ff95c5"
    sha256 cellar: :any_skip_relocation, mojave:        "511641772c82be12e57a580570c2c42b3f24a6b929863133e637f97ea5109daa"
  end

  depends_on "go" => :build

  def install
    build_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")

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
