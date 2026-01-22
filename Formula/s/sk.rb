class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "0bfb6618c8ab0c097ef3e57065e6f2b79fc14b96aa6480e90e5dcac2dc1d6202"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ec329a5a9e049b16d9cc772082c1b734f93a37df1186ce0bdb5fd02996da373"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9ab3812f3a20c1af4a3ccc67b54794c8ec0cb4db49827c09aaedde61fff4142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775ee29569ab49adb403ece2bee5a872234eff566fb59740053187048458a87b"
    sha256 cellar: :any_skip_relocation, sonoma:        "81db3ffe9de0bed7433ea6b7fc7f714e6da4a6a748671a0e892d97618f1b2757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8761128d2dd140d511047212e126e8e2d2a7b443a3cf9dec104361b27475a323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda5b357f97ca1949238356fdf14b0ddbb119ade677bdb5390fdb4fcd817da9c"
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
