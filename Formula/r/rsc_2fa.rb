class Rsc2fa < Formula
  desc "Two-factor authentication on the command-line"
  homepage "https://pkg.go.dev/rsc.io/2fa"
  url "https://github.com/rsc/2fa/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d8db6b9a714c9146a4b82fd65b54f9bdda3e58380bce393f45e1ef49e4e9bee5"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c32203c0d299aacfd3587e37f7bced92c8e19361b6f8665ccc47518f49949ecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "075220c900e04b25fb10ce49bfe0b762de933b9b235084c7bf1457460f9f0a10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d16796c1727ca9ef2310ec669216fc6ec64053e28781431aaf4cc4186828dad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c88d62abe74ed6cc04cc70f5c4b86a9fce044672beda3e026aff13cbe68a28ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f832afe87766e2847eadb453848ebf881c0c60bb608a71640b6c237ec44b9069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6db5849c61249766bb9ac2168f2570c87b0893e19c7600e9749f375c6934ffa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fe85bab87545f8cae9c24f71f5a14020032d169a0172e9509352eaf6aa16dc3"
    sha256 cellar: :any_skip_relocation, ventura:        "ec0046a6c98d1fe4ac25ba97d805234e68b79158fa09019ee6a3ccf9ca0fcc98"
    sha256 cellar: :any_skip_relocation, monterey:       "aaf3afec742c3a53fd5a78e6677750b90120bc7803ac93c004d4f337d285a605"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c0d499b3ee3fa0a1d2934e05fd36cdcf75f10710ec3fdc9192d07f74074262b"
    sha256 cellar: :any_skip_relocation, catalina:       "7c0d499b3ee3fa0a1d2934e05fd36cdcf75f10710ec3fdc9192d07f74074262b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1bd79a650b944690c714fbcb94ccdd70424082eccab025081d98eb52dfc6ff2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c943ce568138c782321aaa436adf79d194707bd140f82b50046aff80851e3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=mod", *std_go_args(ldflags: "-s -w", output: bin/"2fa")
  end

  test do
    out = shell_output("#{bin}/2fa -help 2>&1", 2)
    assert_match(/^usage:/, out)

    out = shell_output("echo AAAAAAAAAAAAAAAA | #{bin}/2fa -add example 2>&1")
    assert_match(/^2fa key for example:/, out)

    out = shell_output("#{bin}/2fa example")
    assert_match(/^[0-9]{6}\n$/, out)
  end
end
