class Xh < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/v0.8.1.tar.gz"
  sha256 "fecafc61e612b53bab1ab5c935154e9b96190b0882ff6e6245aaa35b479f305a"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86e2d10fe797a9583a42e7fe028923a8dffc63458eb39ca785e7adfa75fb8422"
    sha256 cellar: :any_skip_relocation, big_sur:       "af7e199fe0b18f23efb73d13575f2a389e59fe61d60b50d849ec10fc46de9ca5"
    sha256 cellar: :any_skip_relocation, catalina:      "171279e3d8a5154a701fccb3daff418f020406ec72d722b2c127f8f7576b4971"
    sha256 cellar: :any_skip_relocation, mojave:        "d4dcf1e911b879967826035906510a9a6e1e722039e863a7d1a1d425a6cdcf64"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
