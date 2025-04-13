class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "955f886ff980072d8ebe0a8c1d25bd67617cd9cacb0dfda84d28705132d2d72e"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d307605dc690de7501f0bafafc35731bb575a3c21b92e786fbd66aab3ebb2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb286bc65050ea2f360cc19265521fb44282a47371b5522946b56eecdf99aa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c2a97506b4f0baf360dc45728ad61fb1cf2a51182a221d2b48d1aa1084a87a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ee3c679c58716ba86d10ac5d45948c37c377add0e4a8afdffb48365ddba1d7e"
    sha256 cellar: :any_skip_relocation, ventura:       "72b0a5fa4b5561ec7012283ba4940d3984c022947499596c5126b664d2a13fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b258450e657a0bfacf8e8bdc455650d1843881fd07d5445c6f787d34e849f3"
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
