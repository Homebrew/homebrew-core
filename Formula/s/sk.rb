class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "6f160afaf74cb502dd9e8ee84aab5211c20d04db56656493045c292ff1ab47b3"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "044fb250608f7535838ab2a4f9bc9726cdfdf19afba4c6f4b0ab46c72c374fd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33dfb80b7e86aec5d95e0085dd167e3ba73909f982d0cb6d2587dadfea9125b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d3570fcf9f3943d1159358fc52565dcbe0a856cb912296163bcab4194e2f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7c2a3588bdfa2d37ef615be197647291549f9591a94679176cfb06bcb251fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2de15e3bcaab5124572ac4e0f1e03e3f67a08b1bc5f80aa080f1db7d4cf9972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd5e1e5b0b6133a05ccc2d66139dc095ec442f14ae8b006a5bfb7ac41ff6283a"
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
