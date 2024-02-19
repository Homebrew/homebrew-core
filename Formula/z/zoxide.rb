class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "f733fabe5d25978f538a4d4cb7a2732a066adc21eeac8e8110f9aedd47f38470"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "945cf578c0abaa57819f781e14d6605fffc34e85e27c25a8c73db7fca3e07121"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b87c3f12409f742a56fb6c7758f8af6b779c532ea5fff75c88882b23dc459404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e3392fd1435fb5445393dfb43a82ebe55b58ddfa7f873fd7583e6d13b4462c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d47b500b3747f5e119dd74771b460a660069584fc83b97573cfec8ad39e14cf0"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd2d1a4737c7f8316e87aafea3bfc4ff11cd770e49d565ef4a90e3d2bccbac9"
    sha256 cellar: :any_skip_relocation, monterey:       "fa50266c2dc513e8b150b361d18caa5cb837aaf18aa2446961a279d04f5fc32e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918c684134dd7921085f4337561007d8ccfaca055eda92a002fa3d551a37a37a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
    share.install "man"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
