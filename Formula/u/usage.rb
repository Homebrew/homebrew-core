class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v6.9.1.tar.gz"
  sha256 "b5c03762bfed69d9416bbcc8f381e1257115ad5ae33b94d94739547e65313f44"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "110418cc39c01df69073a9287c1611d076c50585b0946ba0577e8f04240ad0ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02d3d16742c9e48bf732169a3504cf868903b9890e93839dc15a577c289a2bfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "007c9c876a686b2776260f3691446f3af4a9d22f9ad1ba9db378417eddc63f02"
    sha256 cellar: :any,                 arm64_linux:       "498022b10b700c2ccdff4d68a984c6173b79829a418c99fe309a5a17ef242c9a"
    sha256 cellar: :any,                 x86_64_linux:      "a5a0b4d9d4c889ac41dcfda2f0d4bdae173d930e7c55485fca0eedb99083b9f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
