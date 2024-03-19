class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "b701f1cb51b906b25f19e811f30115bd6c624fc5339569baa5819be3a6a34d4a"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "191a9c65a0f5ebdfc34407fe56e7b07159cf49a41b896943b971fb2a96c0f9d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1a67a7122fbbffad07f921e37a1ef7a22a1ae9e8fe2dd08565d60b87075557"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9309f88c09461e6732d4039fcd3c111cc4aa07af7d437586bfa9c56b680bbb30"
    sha256 cellar: :any_skip_relocation, sonoma:         "349ae1f2c61ed38f6222e88c33e40c049241bb982c034171f7b9e3726870902c"
    sha256 cellar: :any_skip_relocation, ventura:        "c6ce4483c471f5e4695912d228152426c8f6cf262f00d675d86bec6ac7595c08"
    sha256 cellar: :any_skip_relocation, monterey:       "f0391e6fa72e46b9db867efe73a87787f2cb7ed503589b3ae2e291f0f12aa5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d9fd0ccc4e2b27c6819cb085134c7eb95a944fc49b5c84089326b07d860ae9"
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
