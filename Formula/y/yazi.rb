class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v26.1.22.tar.gz"
  sha256 "83b8a1bf166bfcb54b44b966fa3f34afa7c55584bf81d29275a1cdd99d1c9c4c"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7e4ea45ad895897d8dbc4374f466a78a45bb4a7f467d71a645c3e54ec07f90e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c5d64a2a83e767edf23e79cdaf21e6e855032121a1b496b5140a41d25db4b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c44c4c10cadd7c6bb5326021b9c3adc04a63ed850564610b58fd2eec87a51bf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5daa085c0f82527a4f85dc665ba6bce8995a34ea1a6c956f8f168d9161771ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47032423c94301f997014f3c0a21388a8c87eecc3fee608e35e359566ea4e6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1916a132cbb38f43ae3b346df0dda81e2bf2b3a14928122f2088f55d14a0a7e"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    ENV["YAZI_GEN_COMPLETIONS"] = "1"
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
    system "cargo", "install", *std_cargo_args(path: "yazi-cli")

    bash_completion.install "yazi-boot/completions/yazi.bash" => "yazi"
    zsh_completion.install "yazi-boot/completions/_yazi"
    fish_completion.install "yazi-boot/completions/yazi.fish"

    bash_completion.install "yazi-cli/completions/ya.bash" => "ya"
    zsh_completion.install "yazi-cli/completions/_ya"
    fish_completion.install "yazi-cli/completions/ya.fish"
  end

  test do
    # yazi is a GUI application
    assert_match "Yazi #{version}", shell_output("#{bin}/yazi --version").strip
  end
end
