class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "191edd7ff583ad674b0afd703480213d616f10285ac6939f43fcf784b3d8bc13"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a094e86fb30902593cc48e0ddfeb847e2ef50e509adf2448caf488199e0a338"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1326e9d0317915f3aceed9174e986f1ae832add5e23adbfad42c0f7dcfa6fa49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb113e4dc4567ff2322e2f850ff6f3297dbe7acfb06d52ba8b214b84b27bb59"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc90349b63d8ac453b917809c8502dd562746b3c7977b879cf1b211ac1817f71"
    sha256 cellar: :any_skip_relocation, ventura:        "08492bed9c362a7ac20e1180115d00d4d168108f01fecd24e211c144691fb8c5"
    sha256 cellar: :any_skip_relocation, monterey:       "b1fae56868ae94612d610fb34834546087556d166799bb60f6840b6c29a9dc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f02ea883759fe94f93959d5b0fa5ae7d6743f54c1cef9be82db6e2e4a78a8294"
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
