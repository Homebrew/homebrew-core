class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "67f51fae5845f21752c0821de43257b2bc233477ba7f5cebfdfdefcd48b1253f"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1b5639475d925bcb442cee8b5cee809d9aa1e83f4069d3fc84cbe515567987b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdec0bea675cd3b6f22b9eb530a27df31c95aebe9ff33dc739c86c829f8116a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "962f2e761ba2304b20d52dceac49a5ea94adaeef7c7995056d572258e79eb5e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f882cc8d49bb14d8f564a0ba99d14d3325091b3db59ea5a16e465c6a7c3cd72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ed6c3e497656edb909f18e2fbc296927ac50b6444efdf7d6b445f4a8367efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5bde787fc3f9bb32e7016a25975ce09365794f949d2af97f30ddbc55fe9882f"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", "--features", "cli", *std_cargo_args

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
