class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.2.tar.gz"
  sha256 "83b788be6b62b083abc7f7a77a36c217989171db2b1dc4249a445ab4e00ef2a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27fd51f30d5cc9ac035005b26b2a5d5a63a2ac1340065c91ba966556a234b4df"
    sha256 cellar: :any_skip_relocation, big_sur:       "034b62787ee92478925e250d8f72f4adc69c7a487816caa2bc806dc717f6d9fc"
    sha256 cellar: :any_skip_relocation, catalina:      "dea572476854f16504a38505df56878dfd85e3566a7cab0e9d3e1d27196f2874"
    sha256 cellar: :any_skip_relocation, mojave:        "53a16b328f2b1bd0a6562c5123ccd70ad97c4887bec91479a03156b477c2c369"
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
