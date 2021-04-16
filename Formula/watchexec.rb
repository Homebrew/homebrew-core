class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.15.0.tar.gz"
  sha256 "536366e294047480ebfd440edc473690c226f23d07ea166023d1a7e8953c4f34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "58a884fee5f4ecd11b8f52a7125bb3003d597b5c8990b2fb1582d55a1f63b974"
    sha256 cellar: :any_skip_relocation, big_sur:       "06e38ca97e061c2db29a73bb207ff0c5eea1f8a4780375efaf18de1cb7b7ae73"
    sha256 cellar: :any_skip_relocation, catalina:      "7b4a4b7bba4c48b625389a395b3bec51de72c1d212f2d234f0fcf1dc0168595b"
    sha256 cellar: :any_skip_relocation, mojave:        "a1dca56f89ceebda0007cb74ce24f16afa9470b8540b112d30d145b7747c0f6d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 1
    touch "test"
    sleep 1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
