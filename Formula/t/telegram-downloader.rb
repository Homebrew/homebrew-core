class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "df5e1e25d26a0612a90aac5ca341ad3fc1eaf6387350f5e1e99ae2e25158d1e2"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8073e3eaf39c58ca99c8a050f164efe6aa431ce0895f12f4b091628ac435370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bab8645b04e2546a408ea07a1ab858ec8abd78a10f18e8c42f04585dfd893473"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "283ac7dc06b8288f5e74ab62862f2eef704a4031c5ea6c51edfe001e0900ecb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c1bc78c5814693dfbea03c61caa179b1388380135c8429b087649401f08585d"
    sha256 cellar: :any_skip_relocation, ventura:       "7ed00f11f02c5710d8c03a3260cd6ee1dcfc96d3ce39b6f7f2b781fb09e8ea0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2624dcc75d3db01579f625c9bf4a9e225641d73e2e4a577ef935efb7c1fcefea"
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
