class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.2.tar.gz"
  sha256 "83b788be6b62b083abc7f7a77a36c217989171db2b1dc4249a445ab4e00ef2a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49a9468a04249f10a66e8aed8abf64b32da95d5202d6aaea79478ac33ef06168"
    sha256 cellar: :any_skip_relocation, big_sur:       "756028c572cb2f9ce42f240cddaea1843cfea25382cac0216db10a6592e39431"
    sha256 cellar: :any_skip_relocation, catalina:      "a4f0105dbe605fc4321289cf5394fa03a4396e65ceba4a60243021603bded693"
    sha256 cellar: :any_skip_relocation, mojave:        "4098635dc27ed2b2edd9409e8943539d14fe7c97de4a6963faececed9c90e38a"
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
