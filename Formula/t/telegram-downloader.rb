class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "aaae011e6c2f453a9d53b08de87dad04caeb90b0a8e9bf3c07abf1d2eb84a33f"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "434213dce3f08f6e3b52ae7dfee33784b711c8ded40a9faf93dd5d49ae15d40e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3402272a6776577189bd2e0c5d9886c7fb3ef69d765341fbe8af281725a9247"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a67bb099adc69f85c2d6fdf57f947703bc90427f38d4e2390681159d80bc3871"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f9f42065f44a396d940e960bbd570f8f1ed929227efdac8b13a15e185f3da83"
    sha256 cellar: :any_skip_relocation, ventura:        "761e4dfb7344ab0cb675d44f864a12cd0cf851be55ec9826ee60b54886eff720"
    sha256 cellar: :any_skip_relocation, monterey:       "44eff0b362b5c042c9056eef726caeb49e5e3c2d5f9958b3ea593b038de91477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2574f1355d0d29f4621e4ba8710c377f06e6fe39697f3caf1d236ef218c4a5c4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/iyear/tdl/pkg/consts.Version=#{version}
      -X github.com/iyear/tdl/pkg/consts.Commit=#{tap.user}
      -X github.com/iyear/tdl/pkg/consts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tdl")

    generate_completions_from_executable(bin/"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
