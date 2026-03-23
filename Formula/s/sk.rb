class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "4aea53cd711551f35e67e08a58c8e015009751989da990dde29c10e8c546f581"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6847b4a41e19f67928d5ac5992755052c30b144366bae81de516273e8b7cf11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76f31572b52d5871da72071f6b0a1531ed78a44b24fbce686dd589d337f78ede"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ae123eeb53386114c6e39b227f2cd2ce6cfb39dd408cf42f3a85698cf16976"
    sha256 cellar: :any_skip_relocation, sonoma:        "f545af1f0de6a04893845347154ba646745aa0d6efcb0ed89a81d7110b95d299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cfdba7e43e05c53de548a6b0a4d07722ee81490f9a1a09c13069d9ee813d065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "102928929ad773d15e4822bfd8f99a69cfad38ea94338e4a81d376b5f54d1e91"
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
