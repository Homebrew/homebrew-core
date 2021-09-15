class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.5.tar.gz"
  sha256 "138dad27a7a272171ee28aa34a10c3552154121c01bbe7b613cd4d12bfb07e41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "348e4070868a24b3eeceaeb2d6007813fc22f10f57ea3d0a3c5cea592c11b1de"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3ca78eeca3939e6b605cf5b7b686c7e6b7e23d2d452edf33c34bd2c130047dd"
    sha256 cellar: :any_skip_relocation, catalina:      "b942b8bba6d03f72566d317837330d577c0d0fff45573baf3f2642ab88b50479"
    sha256 cellar: :any_skip_relocation, mojave:        "01170393b63e4764b65a9e443dd46c8d4f952cff9114b6fe400d895e90de3ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac7802a7b9a2d8edde5831e0d438b2a2ccb3fca5864c08b6b9a173f16bb276bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
