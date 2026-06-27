class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "a0b4b398be72deb7d16082fe7013f70d87396986b3b8a1e892fad5aaa8433fc3"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d7792e02f7cdf38e89f0caf0f64b5818eb0c49264f304c76b2aae576391146a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b84ec8438d62e6316cb8ba336afec29daaa099e188cb799f04451ac7316d9c76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "477f49985c1568ef5e06b9b468f6b8684f6ac701e2f2a7954f6be3c490a56d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd7cbe9af4b2e4197538ab83eebaa804efbdfdfe7b9825f28500a746eaa2b2cc"
    sha256 cellar: :any,                 arm64_linux:   "4a22a586800151f82f6fc51b68168ade3a66358db18e615fe2ae083079068085"
    sha256 cellar: :any,                 x86_64_linux:  "54677c6621880256c4181c4f08383c8c27f473980e9a72ada55497196e6715c9"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "cli")

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
