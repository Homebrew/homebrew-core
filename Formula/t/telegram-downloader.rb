class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "228899c6ac2c4e3317e35b56751b366c658746a15f670567022aa6a950608bc1"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "022a6a5206c4ccdca15699bc374989dcf429545a7e5333362ea3161d6f2ce8c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8ae4c69b62aa40bec840f1f4d96ee354b56cc1861589c5b16f71b514b215312"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53cf6c013ef8190eb58c4b515d85b20f0f6fd605e2dff1a49b637a87b77a93a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "07e48be33404b5e1cafdeb682342a1dffbccba0de95ff50c2788865232aa7b2f"
    sha256 cellar: :any_skip_relocation, ventura:       "ccf7c91930b9650dca23fa0561b0f11bea42ef0df48ea7d7ba93c69ffb319445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f046f4b6861bc8979504049492fac2e3ec473d54bb89ed4b4d70d58c855e9c2"
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
