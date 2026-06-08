class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "485e621d220174a472a03a3aa92e3e8738ec16b33ff714e9d0a1faa467970835"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8578a9f707c4320dabeacbab1880c69a6a9587e9bf1edb8a16072809fca33297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2577ed6987eb57b9738e978fcd4a737bf13d417b7e5208a3563eba98db91ef2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28db7bed02a25d168318d560dafb52ac692de5bdd11499bf8e7fa5721b9732e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa59bebd74aeec7f6697873a512e83f46cf4a05eb180170876e2c38af1e3e1fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74a87af08842654bbb474e625308079e529fb5d21f60f73b0f2993027ebddbd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af745121dba8975c1040ef54f65537ad57db6b232bf37397fe1c3c241459abc4"
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
