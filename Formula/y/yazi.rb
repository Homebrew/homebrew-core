class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b1292be2d071a1a95fd7732baee8c22dd20f08c1facf560399e61e520dbee1e1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad8d79e55a59e919d5eaafe5769b45503f18c65d76f8a64a70339e3103f9c365"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e6d4b794887f9a67276079208f2978dedf76f4ade847d0a4982c25b41180909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc03fc136700847182b86e1998095c5c9708b7cc16897ee5d3a0720602afc379"
    sha256 cellar: :any_skip_relocation, sonoma:         "a20681aebb1cc599e5456009b00685fa9c62f9f81331d04c10b60702e05eb7c2"
    sha256 cellar: :any_skip_relocation, ventura:        "d098d19033bfa35be90c7ac8306e02b3b0478492a9af93c5828830de9f0d51c6"
    sha256 cellar: :any_skip_relocation, monterey:       "7481c0d323d46011d32f9adbae546f61924652c79709a711440eaca911a3e235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0867e77b054b6a624aa05721f2af1f4d01ff3d7569140c2995bb2ddec0ca833f"
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
