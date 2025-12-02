class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "3b80a480f718e83a7bdb85f1989093d17a15048ef0cd380e844aa9fa556a6ea9"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70605722117d373bff3d93236657b2966f25a7cb4a113397b5c426cb10974dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b8f18dc0942fbeda0446434951384d235bf963450d40a184c9058c41e1b806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3752fb62a4ec1a2a221e97f87d29a8590e2d0d29a9ce43a343ebf51503e5c466"
    sha256 cellar: :any_skip_relocation, sonoma:        "2806d91e8160b719bab4da737ea32560aab848a413aad0a45945c7bd1c9193be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b5ad3038ee6ebd916871a0572c216449d0b301ad754cdb0237a2d1b7b0d16d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27c3d0ed8aa68c55fe0920e96f4a0a7af76963faed323003e23316c1166dda37"
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
