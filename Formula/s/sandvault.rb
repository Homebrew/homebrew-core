class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "b4e92a981a393963108a429da8396aa2b8165c01ddad0004c8be435d85f83c27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "692067dc333256a56b89851e0173906d47843488632238883523a780171f5aa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692067dc333256a56b89851e0173906d47843488632238883523a780171f5aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "692067dc333256a56b89851e0173906d47843488632238883523a780171f5aa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bd72085164cf55393cc64fabbf6e550f9f5bbfbf8b8329f7cea362259d9529c"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
