class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "76e6f1b968352ea3f13add7ac7e0548cb7c9b5d2beb880c890808d9be0a6b1d3"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf071aeea1f93278afcb4027d2c46021eab49995b3a3042655fd8d88655c7f87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2b858767dbd763dde8370f50240fe711305acecac2eeba907a3828a0860eba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de63cf221aaa1127103287494d38523f862bbc2e3c739de5571702e93d2163b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5218cad848f75c83ba073189b9143b83f614012bda6c914224986d14f5ae0e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bef2bf6a340de5013884c677548def6389d76bac7dc7bbece760d00cfcbfd1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3733925781dd3bf6848e30444dae867de4dd1fdb75333261b2a70e6549cf474"
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
