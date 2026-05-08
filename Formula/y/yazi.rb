class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v26.5.6.tar.gz"
  sha256 "a18445df86a20068f7b17609d12d6f635de488958579ae7a2b143a244ba7e63f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b31572f1b22a938079f658e5b9fce190dcbba90aec41b052cddfa8950d883605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19349642822262d015014fb68ffa11927f5eed6b60ce01da5f91282e9d0b7d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa9938e057c497ad4be2e7012d93133266b970e3aa0e763fa2be8bfa35d3e7d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e8278a478e91973b686f46b2543a4ded02fcdcebdc8b05793e85782107de2dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981c7ef81931fce515159a9360b6127d025d66aeaa1db5f607157ada64585be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a80c02b0a7d6e5f3e22415cba4fc5914c7f5f5956985d7b44869c487799e55"
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
