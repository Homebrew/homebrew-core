class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "e0fee383c015777eb7aea1e5ed932b06dee6da990583c665ecf1389600e2789a"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b3748e0d35065b6e014b48a62bf9ea1e23dae9bccdc0bc27848fb2997236493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16733f1cb2a10376c69e214a43f96b80d7497a576b4b1fe37e38e6e6a8202929"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e113083ee552b5cc4d1b349d1cff6d7d1dbc55aa6cffe37a046139b771eeec46"
    sha256 cellar: :any_skip_relocation, sonoma:        "eae7170033006190a2d87833a87099822e731628b73f76dc17ccb07303144c5e"
    sha256 cellar: :any_skip_relocation, ventura:       "dd13f48336301eb1d27846cca56e5ce445026d50a42d89a0234e045b269758e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad49da6c88fb4555e882a9afc1c0d3f98490e38653fb17656e7d55869b2c9a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96f759e71d35148a4a16d00e84254ae8452d192b589ea1c09201fa7f41afd542"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
