class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://yazi-rs.github.io"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v26.9.1.tar.gz"
  sha256 "66857f1b670469daf258edd0bb2ea51d9ad3e2cab4eea9684028c80059fd6862"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67237c64fca1f36bce0820b8a23d6fc8e777282aab39574cac47f05cbbded607"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76799ac47d8b4241630c66113d180dd5583ad71b4bec16f064e9799bec7ec57e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5a5a2ca56ef283bf4ae969214c57899db22a676a9cf0471c3649eed375e2b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "71fdd1049f3bfa6c23a5ea521c0a688b29119b9b73bfb6c199797b0dc8114d56"
    sha256 cellar: :any,                 arm64_linux:       "53cbe7ca6aa579b260dfc4ebd495ffa8d69534fc233abdf08b6af6e538d24bfb"
    sha256 cellar: :any,                 x86_64_linux:      "d4dd65419e6717043914ea0467b68cb8a10e400419b242c05ecb899a3d1557d7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
