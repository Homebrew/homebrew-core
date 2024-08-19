class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "dc54c47ee761a3e6ff31fbbb696b40e893b1fcdf2d2d15a96c488d8d57711097"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9af5c5c135977368bb28aed9a5dffa055927cf089d1ff89427dc855fe8432574"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd74206a4ca2366b7829e3d6605b11fa4520b2cb5c188541695307e078c20363"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcbe603d44b0c137ace78f9ee2c16f6e57a3b44e24f61f7dc11c0d0ecb867b67"
    sha256 cellar: :any_skip_relocation, sonoma:         "bab9809ce8d62d67f3387783be60cb3aec6192ba766a03f71f967ea06ab3c9d5"
    sha256 cellar: :any_skip_relocation, ventura:        "ebbf8d4863c6e02e7e91e6a5b3968923635f3afdfb04acb960581e24b3d14cc1"
    sha256 cellar: :any_skip_relocation, monterey:       "a03e982796bc52b28b8d079eba0ed87b48e5d40a8d9f5361c30c3838cebbe399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d05800a832ae7ff3d0129adca23641da143b4dc2c58e08f54217f0c8cacc07e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
