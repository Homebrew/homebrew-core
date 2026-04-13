class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "61b518929c05f5eb36386bb5d01fc85ff1c1956223592a52feda47f15faaa5fc"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11453e2008360f1c3fd259a09f1e662a97ea50ff2b2add1bbf7174bc6b545887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cffcc3cca28d77e5b68dd88d126a7f6d17c8aa7a582b817d284b0e071f77885d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "223f28d9518f67b1ae1ee333d661ae6a762949e3f06b71226a60f6095c7a6343"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a06af5fe69dede9d66af3af4238d8f8f29ac327b9f404830a8bebb014b68349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3da7066f0ba2f2db4bfe0de854d5cc2d535be1c8bf7c4d59176514c7ca87d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5265b9515152ca3e103db20a166ae1aaea8e3bc40d8500f678aee3c9c31ff9"
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
