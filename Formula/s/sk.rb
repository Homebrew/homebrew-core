class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "934127f04a01ac0daaad0c273fe7e705fc01135a27dffe068c156528849f223e"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceb2f32141dba4f3757c2aa3d540d2b0c34f8077f9b0d01e1f954721adb493ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cba1e488526c8d68ec4764c706f4c11ab5881b2e77a0e534854d058e101c5921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78add48cd38c4e6d8b079719354b163315c83a8f3c01e85b22019282de66a67c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a619a726cc7380d98f20f586da9651a46e18ad771328b798e13fa1902611d49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae464577b29fd6fe38c0e672cb7a039937259476fb12b27a7bbf0fb09b7692b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eadbcfa2e6fc1d7550bf1d56b482f8f048b8affe55c3882c9526358a5fa3576"
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
