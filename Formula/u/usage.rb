class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "81c89c5aa5e7347a8376bf1cbb452dfd1cca8570b71792b64070847bfee98798"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dafc51df30e07c6a0b8f5c26ac967d7799709c14fc7686e6c9cfbdb04eec911a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4699c7ace2b448027f176d5e604852905882921365331021b39dcec0c8c51b76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64b54b95af85e52050cd612a419329c0dff59810523c0829c9e28a6e653faa46"
    sha256 cellar: :any_skip_relocation, sonoma:        "4db216bf36873dff697c3222f78251016a64e25ca42bf41ad7314202130394bb"
    sha256 cellar: :any,                 arm64_linux:   "de2ce04a2f7d1a3a222c28a877a54c409a20cd45dd866c7966b002b2af22259c"
    sha256 cellar: :any,                 x86_64_linux:  "642014441a7900838d243da6aeed791f82efb9a07353a9d85442a6e202818bd0"
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
