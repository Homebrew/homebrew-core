class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "73d94d344e213945f2907be2f2e9c7e10a6a76a2c084fdd23d4b5b2191cd9a49"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7ea231c234bbddcf524686219b25676d98c923930ed8511090e93ced14cca13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "019db7aa2c9dc9a91fda57b2c04f07249f31c7bbbdabc7937c0c116523bb85ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0901f760e4978713da8598c761f14ed6c793af99211254e67d12e62f3864844a"
    sha256 cellar: :any_skip_relocation, sonoma:        "24dc299a3d41adaaaa41bfe14e10055c0e0b41125d9e9f3bdeb26bb5f2096f6c"
    sha256 cellar: :any_skip_relocation, ventura:       "1771773d1c578965491cb3f7feeee03dd2eb6eaf83d33049ccd3db471dfc7aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9184ee76388978d5bfb1cfe8a2ff6c6eca254d265d6bae5b053382b91b631e01"
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
