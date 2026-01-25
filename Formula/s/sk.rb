class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "74ee1b208fefbb986aa655fa5343953f7d14bbbaae3ca536b279672014a8a666"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aba9b8c28f2f63f186c3283e86591c6c1384ccd1f596a9d720046f46eee636a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e61286cfc45a14035c509658258c53442947747f9f18137c1b73389b5693e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fef8cf8e0364da6c1ad966b2c725c09e92040c10c8a3e4fd2d781faa6a92cc1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "545bc618c6105a16a74f9cce896af246c2ff353c49f89d34dbf87b3185f591e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8927e461a04ffa4ce466537141df60cbe221d572c8326314d851508f4ee12f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb8be3822ad161951a7e15ecdef71981c2bd5bf5f46f09e36aa0aa4ec8fbc869"
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
