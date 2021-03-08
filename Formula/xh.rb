class Xh < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/v0.9.0.tar.gz"
  sha256 "b9a9386b552f527796f088b5d38effba8fd01c1dcb457cfd5bbfef23ec8c424f"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c8ea9de8e583a8f6c0f5c14f4ae6d0a25abdf9eb03aa86f780385e7de02a77f"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3ec3ce78f987a0a496725954a5f0f1b0803db35362f6397f6254d3218423924"
    sha256 cellar: :any_skip_relocation, catalina:      "f5fb791940e181b763db9581e10e916f6e82f1e581848b7694441d0192fbd5e3"
    sha256 cellar: :any_skip_relocation, mojave:        "4b22aff03193c9c057bb97c37fde782f5a09a8283343db8f87308790f0496b3b"
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
