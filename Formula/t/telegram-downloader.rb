class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "cfb3ac515370aa6494614bbf20eeda60d69a39ef8b9a3c0c7584b6163b9567c3"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9cde8f37ff8be6f6e917b8806ad824b9bd38ecc1b9054f4532baf07bffbe72f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a9deafd1f37eb8d1355a56822c96a42399f775ca2347d3612dff6b0ffd1ed8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdc9eef1f184e7c2c77780e25d29c90558c53df387f88d0ee3b7350740558bf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fa7d1a488e5dca0f15f26fcdb2b7a5d5ef0ad86be419e6caecdd855b16cd8b5"
    sha256 cellar: :any_skip_relocation, ventura:        "71f85a3ae62750463bde2d8e5b5640cc107b441df407c7785848d6c8866975c7"
    sha256 cellar: :any_skip_relocation, monterey:       "e87b9c1c3d6f86dfe49b362e0ce7b6da81d27145f16955f79e147fc7cbc6d1df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83a99450a0b4f8840fe2ed89d291c35b7f2d796958e873b95e0d3158d213f757"
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
