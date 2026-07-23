class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.5.6.tar.gz"
  sha256 "728bfe773b87e9556694a7e66c5479d10b25dde11ba176125445740969c4c73b"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08d2d3acb71e8545552c3695fac7854fe38c212326e65f938cff92b9afe8cacd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c93e8278680b318ce26c14788e0b9f8b66c011c5c98269df257e6172c9c30d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eae10d26197ee97ddae14dc8cd93cf33149b7a14e91ee63cf6ea5bb6bac06c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "60fd3b4c1564ef6d47cccac9743488cf7df575d89186607d59156db1b28fcb3e"
    sha256 cellar: :any,                 arm64_linux:   "a89aa4ea3252d4af8d5bf183b993baed598dffc9af0ccad051b9f1e3b8c73021"
    sha256 cellar: :any,                 x86_64_linux:  "6c1c7be68e1bdd969ddf596f190fb677f54785732b37922ecd0d3a5a42612ef0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
