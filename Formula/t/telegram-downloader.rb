class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "a0bafa3e7054f05305f145e87c5f31827c1f36c71286080e573ae7d5a1df64f2"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c908ec74176bbbb0642feea3cb685924f7fc5d0461ef74d4c27d4c42332ef616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b414576f5e768f7680dccd54fd2b1b1d221a71d9c967ef273c097d66234f752a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7610888ba8515d4aaf7b467a71acfd48e87163cb2054d6d1ea90901f8666f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f3ca5cadfe56e206864f4d9e61e4e64e82094e0c99a31f11e989543575181d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e598933fd4cc7db464dbe3f67d1028fb4dc9eff7f4264989f40bf3e54b4dbf24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48945745c8d80a4b82172529a7c89d730c85ca3707f620855c86c2ebb052f72b"
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

    generate_completions_from_executable(bin/"tdl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
