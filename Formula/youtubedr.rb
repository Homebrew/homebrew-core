class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.10.tar.gz"
  sha256 "04a4f0b745094884fb2902945ac3b1c966fbe4fbd67a027cb482d491662900f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f88cd160ded250e0192bba91a58e359049c4165e3272a2b28ed78f8049e7e32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f88cd160ded250e0192bba91a58e359049c4165e3272a2b28ed78f8049e7e32"
    sha256 cellar: :any_skip_relocation, monterey:       "9e45685eefb31b15bc999271df40b123f7d13e6a4cf780e577c96c417e632d83"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e45685eefb31b15bc999271df40b123f7d13e6a4cf780e577c96c417e632d83"
    sha256 cellar: :any_skip_relocation, catalina:       "9e45685eefb31b15bc999271df40b123f7d13e6a4cf780e577c96c417e632d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "558ca8bf9c1d309d215d9ae9a09d0b41716ebe1303a4e8c1f01731d7ebb28288"
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
