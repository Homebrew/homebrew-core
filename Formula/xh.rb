class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/v0.9.1.tar.gz"
  sha256 "b0cd92b428094286688214fde316e0b9bb668c184989a4a0ec25b5ffae2cccd4"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69de66a0b0d45c1b950afa06e62593c99105db7d886754a53869a59354ca032b"
    sha256 cellar: :any_skip_relocation, big_sur:       "1308e8e103080b426114bd790eed1ad4d2cb8e4294bb748d2625fc68d9f949dd"
    sha256 cellar: :any_skip_relocation, catalina:      "187a1fae69e065feaa51f66f9f36f1b13ccb850f31b56edb4733f00c2f906715"
    sha256 cellar: :any_skip_relocation, mojave:        "f5ea313a5d6a619a035e4234f3ee1074936904bd1fb8d41915eeff65aaf3fb7b"
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
