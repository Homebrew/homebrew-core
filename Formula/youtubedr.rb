class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.7.tar.gz"
  sha256 "9b00a6680a82f5ed962e2bc46b689753ca899bd439613887754000d6a4041a88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d5b44be8f64e6dcedf54068a3c1a4d41f1a9aa91787b7f0c50c7c3b7c186ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0d5b44be8f64e6dcedf54068a3c1a4d41f1a9aa91787b7f0c50c7c3b7c186ad"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b8aeede28612b3968d93504ab9bbe23489fd57d9a03e9fb913a8a44bad5e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9b8aeede28612b3968d93504ab9bbe23489fd57d9a03e9fb913a8a44bad5e7e"
    sha256 cellar: :any_skip_relocation, catalina:       "d9b8aeede28612b3968d93504ab9bbe23489fd57d9a03e9fb913a8a44bad5e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8dd5d0d3c0d31fe8745fb429b495e3e6dce89ab0383555d8ef2061d4db87f2f"
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
