class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "d0a001b859190647c89b72462e8a524d28eedb043db64bae5eb84f1a721c1e21"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acb39fe5dfdb41f9cdab4d1acabfcf70b0f42617d9513929c94d15c672cddf05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7802d2aa2d90eb8d588c0a75facce50c543ccbfb3087c83907fe98a3b2163eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55731335d6f5443f82a9b745f00d8aa92a479eb8d559c6228d39eef7fa666fce"
    sha256 cellar: :any_skip_relocation, ventura:        "49eca819a879985c2559d564774545d98a878ccb20251659988f5ffffada2629"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a2a256882d5f9f81ff317549fe6b745e2e6feda275818c4dc3b3e9895b971c"
    sha256 cellar: :any_skip_relocation, big_sur:        "56cb6e14dec3d19ecfd7446e2c7e39bef67114710560c486ab8254f31ff40841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd19a3b36d1ba362d6d31c44fec123e8d408a1ea23794bdb5f2be0951de95181"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  def caveats
    <<~EOS
      To activate rtx, add this to your shell profile (e.g.: ~/.bashrc or ~/.zshrc):
          eval "$(rtx activate [SHELL])"
      Replace [SHELL] with your shell (bash, zsh, fish, etc.)
    EOS
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
