class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "1ba11397d09e66a1ea08cc6f9df39ba52cb0c74accea26934d0c4799f3502985"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21c573a5f51e526df98c736e3c12ed70f0279962f9e4d11796fbe70d001c8b1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "998c09a0a0ada71a0da856c8b64d7de41f4c48ddc4eaef94a579db1d31885bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "161deb41951ffc8de42769af389766fdf20782ae082d723d214fdffd4d0e5a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "73949352a3250996188d08825472c79f05bfad0400b10746130ce6170d06d0b2"
    sha256 cellar: :any,                 arm64_linux:   "b7aaf1940d9c72e7ab73689fad3c2bcc4e65a10c2cd56ab7d8b20c57ecfcbaa6"
    sha256 cellar: :any,                 x86_64_linux:  "31f186c9f4e4634edafe3b256cf770a53577ccde70ba896a155dea18da3221c9"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
