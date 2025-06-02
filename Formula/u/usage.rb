class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "8a28fe01b2c3b1273e80b113d137197fc62c97a542f577dc2dd2414a236c78d0"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48749a36fe6f537c4fe3e123d21627fd4b25ff38609d4d24cc81f1fad83ea000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3943027449c6376bdfe6a1ddc228d1b3a78cf003dd88c20126f6cabc04a6799b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73feaf7c10b53a1aa1eeee36a906c122a66ba270020ab632172d94cf0e07f438"
    sha256 cellar: :any_skip_relocation, sonoma:        "f31104fa7604e9fea8b2f2c09b90bbc539f18d98e7a36d50bd549507e002c61b"
    sha256 cellar: :any_skip_relocation, ventura:       "470250bcd2129d522eae4da6f001dafc87b4e753d244928905824b4ed3ed25e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e31653c676b32d99ae9e5e7f7fb431ea3d11b90f08013ab7c482f97231012baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752b905bbfd6fa99f56ae3dc6d1c2cc0d430d6c0023dae8a84ef7eb4f5c05f07"
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
