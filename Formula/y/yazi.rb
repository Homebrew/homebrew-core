class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v26.1.4.tar.gz"
  sha256 "17839410a2865dc6ddb40da4b034dbf2729602fc325d07ad4df7dbc354c94c9e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "206469484b8190a0d629fda0f27947e6b7dfb3488ac8c8a6d7df8ec05f6432ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5bbd43a899b88c9ee27c2a830d197d7864a0c859a5d48b88f8c4c3328b8bb55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8daec0e68f6bf1a699c1a2594e814b7ea9d6f1ac8d1cd4131ab9f8805595995"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbd3aee8438f76dc2bc3f28e5fe206816060f9ed419751848f148feec14b7842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdb418d653bf3eefc08f9ea76066fdc43843bdc010dc8b0cc4138a851b1bdba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f79ee80fc8aeaa2cc5aad5daabf880ba864ed64adc695c2ba257e49a8141b9ff"
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
