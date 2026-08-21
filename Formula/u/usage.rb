class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "2e5d498eda9338f9dc476f4fb722e81e6d7032f9186f24986b017b1b5a104061"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0d9516476640ec7a1ae7408e92cd9eaa90ee993a25fe409adcad7ed92f43cae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c47c014a817b0c40568946f3039d77325caa5860e44cb32a1a184e36e54a2e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd2c8630d11c8d29ba4c050f4d796f0392764c247e4aaead9c16d0d08cfc435e"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ecc2a47be7049626b7129ccb9a01976949845b22e17e75b83e9b2872c1a892"
    sha256 cellar: :any,                 arm64_linux:   "133c823a61ed0da00b1e651d546aeb720f4bc9b81470d61c0ba3f2eb84a7de8d"
    sha256 cellar: :any,                 x86_64_linux:  "dc781f93a93a32ce7d7959b46efad352bc2d3fd1bb0fa0f6bc377d73c8cce6f7"
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
