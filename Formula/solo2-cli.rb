class Solo2Cli < Formula
  desc "Solo 2 library and CLI in Rust"
  homepage "https://docs.rs/solo2"
  url "https://github.com/solokeys/solo2-cli/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ae9ef9dd174a8b8294941635a3a66dc9062fd4b595d5f1f6507b5a5a232d6932"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libusb"
    depends_on "pcsc-lite"
    depends_on "systemd"
  end

  def install
    system "cargo", "install", "--all-features", *std_cargo_args

    bash_completion.install "target/release/solo2.bash"
    fish_completion.install "target/release/solo2.fish"
    zsh_completion.install "target/release/_solo2"
  end

  test do
    assert_match 'cmd+="__version"', shell_output("#{bin}/solo2 completion bash")
    assert_equal "", shell_output("#{bin}/solo2 ls")
    assert_match version.to_s, shell_output("#{bin}/solo2 --version")
  end
end
