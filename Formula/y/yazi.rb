class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "fe2a458808334fe20eff1ab0145c78d684d8736c9715e4c51bce54038607dc4e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "01246c17c55a8e1a84628bf5449bd6688e475119f2fd05e4f79cb29111502ff4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e084de5f54b67158697799d3acd9cefea19e4ae9f4ffcaba799a81859abf7c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6a5c5c8a3e95943d5eb81317a0e49067f79b4f5456c07aea888a05ba79e3593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf217fde03079cf5e098cccc87d9151e1f4cf682ea77d330a8ae76b57e387338"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d9b66561784d040c7642ae94d5251df9ea6b7d74ad6b26e4e462391751d9d71"
    sha256 cellar: :any_skip_relocation, ventura:        "8ce84306248d65237e28ea71abef99b259c32a40787e2ed61d878665c1d1ea86"
    sha256 cellar: :any_skip_relocation, monterey:       "769594d0ef084f3086066498968c98611b746660d6bc8d634d732e8509c07252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b71c80ca7a280bc0594b803403217712b1b53a8f7ce2a98cbfd458342c555a19"
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
