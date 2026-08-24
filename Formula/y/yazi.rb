class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://yazi-rs.github.io"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v26.8.15.tar.gz"
  sha256 "60bd4ca56398f0f6ea6dcf88cc18e325583bf5328aeec51d396070944a9495c8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1accaa6b61bf2e20ba634717d232aad110a1944fedf5507dd28e2272ccf0d281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c2128b8c4afdce28330ee6836a5ff990ff3d738fa9d30d07cd3add420d4dd4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c2522e2775b0b82566b0dfa92f8c5c589f7ad57c9bdaf586405d06530bff554"
    sha256 cellar: :any_skip_relocation, sonoma:        "49473a75a0abe662e73c635bd1e20e120ad9d6d19f66d6f8bb2fa3c75bf1c996"
    sha256 cellar: :any,                 arm64_linux:   "f28f3ce185e19f3bce528bab520fa492edf7c0f9182c3c48ff3a1b75708cbbcb"
    sha256 cellar: :any,                 x86_64_linux:  "38cb464d751072da57a10995cbe0881e48c2ebd4c5e65217195463be6d38024b"
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
    assert_match version.to_s, shell_output("#{bin}/yazi --version").strip
  end
end
