class Tmex < Formula
  desc "Minimalist tmux layout manager"
  homepage "https://github.com/evnp/tmex"
  url "https://github.com/evnp/tmex/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "98cd4046421b6dad611628261932243481d2454c09e6670b3f7c09f48483c81d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e00c8b7bb9fa42a09334ce2d42d77842952f13d62a1483eec2247d82e144d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e00c8b7bb9fa42a09334ce2d42d77842952f13d62a1483eec2247d82e144d18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e00c8b7bb9fa42a09334ce2d42d77842952f13d62a1483eec2247d82e144d18"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8d600fd78cb7cb06e754aed87bdc33ad80b9c835a39528909192bb08f57b383"
    sha256 cellar: :any_skip_relocation, ventura:       "b8d600fd78cb7cb06e754aed87bdc33ad80b9c835a39528909192bb08f57b383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8d600fd78cb7cb06e754aed87bdc33ad80b9c835a39528909192bb08f57b383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d600fd78cb7cb06e754aed87bdc33ad80b9c835a39528909192bb08f57b383"
  end

  depends_on "tmux"

  uses_from_macos "bash"

  def install
    bin.install "tmex"
    man1.install "man/tmex.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmex -v 2>&1")

    assert_match "new-session -s test", shell_output("#{bin}/tmex test -tp 1224")
  end
end
