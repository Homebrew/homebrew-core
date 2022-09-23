class Solo2Cli < Formula
  desc "Solokeys CLI tool for solo2"
  homepage "https://docs.rs/solo2"
  url "https://github.com/solokeys/solo2-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "f797a53046f7fb66ffd9f76063c4b9abdd88299b89d18c28a451a4f62573a334"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

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
    assert_match "Empty list of Solo", shell_output("#{bin}/solo2 pki web", 1)
    assert_match version.to_s, shell_output("#{bin}/solo2 --version")
  end
end
