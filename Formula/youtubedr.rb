class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.6.tar.gz"
  sha256 "455a33cdd07698ee8a0227d029a10238a15a747007d09647cc65d45be29d82b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8c28db829fa960d0c6614929308f0428075fc8ffe435fe1fb1b3220137e0975"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8c28db829fa960d0c6614929308f0428075fc8ffe435fe1fb1b3220137e0975"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb321d9d9799e3b8a9e722d24137eb4547b717531018a0e490d2ef134ae1d6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bb321d9d9799e3b8a9e722d24137eb4547b717531018a0e490d2ef134ae1d6c"
    sha256 cellar: :any_skip_relocation, catalina:       "4bb321d9d9799e3b8a9e722d24137eb4547b717531018a0e490d2ef134ae1d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818a9c3ecc14c9732b63031c83ec1a988a5ea6f8c362e87491373e11ff79b9b9"
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
