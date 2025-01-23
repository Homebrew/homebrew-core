class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "24dda392d0ff96b9ac3e16ed38169f8b5d0697ecc80e6d83809633b19d5f91fc"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad7daff3ddad71a0c78a906dcdde061e06df87e21273497a8c793aaeb88a6df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87515957cfa197efc5bd4d1a838ab474bfd95f296863b29e0b2333df5849ceec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0831ef0ea6471f3100cff507fa847a9fee2dc8054a0ec13d497646653f2733c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fbb49370725842e024a57c17aa4dcb36198c32079b8f4b307aa9f9ad99e2b98"
    sha256 cellar: :any_skip_relocation, ventura:       "553fd19caf48fe1e93323edc6844d605c5b1e3a626caf105b98e345bbdd00a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf7a942125d16280177c86635070f55a1bd9bef94d471f78f7123945dc50814"
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
