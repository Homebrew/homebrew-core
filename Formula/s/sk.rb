class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "bb74eb7f9751f7c43fd634c5714f612eae67830db852e74c01a4d83da8086e3c"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "140348256faebba11c76b19d2cd77c97e727464973a8b23cf3316b43d08d25eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f386af4b7be1b428ab05144a677370623b73ea630d0ba9ddb8a3308d6363b22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b08e77599994214e3d2565b9a36644299b042647dcd775c3965d56b0a2182aed"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fdf4fdfdab75ed240e08f4b3a3867c81cb37c791c39887fafcfe8057a7cce8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d240cb59c390c33383534719297cafed80b84c559fac4972a36fa8c97ff7c149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e926558fd05bc33109328404f826a0ff62ac9bcd43101e8633f215760b22ac5f"
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
