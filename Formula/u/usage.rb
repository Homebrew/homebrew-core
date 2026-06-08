class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "949d8fba0c11f04cdf8ed65151481548ecc2e9d5c92d352bf8eeccdff325e716"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bbade2b5d202aad59f134d3b2afc13c72c1a6b8eb9fde62535ea77302594c96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9990fc6c1e34e547d13f6cff7f2ba938fcb64f6fcd3f0d73d081187d08e32a6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eaec19211a6c4315be5c8c5ad51df5ba4950ccef6f1ad2e2019135f63aa72a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ea61b571e5c0d38af4f7cf14a0d75673e8926c38a7a0e753b0d3fde898f699c"
    sha256 cellar: :any,                 arm64_linux:   "53bec9abdd161c77b41fa8c894bea854c36611947376b57f313ccef307fc3b5a"
    sha256 cellar: :any,                 x86_64_linux:  "e0d894f3581bcf5e98abaf60b04197ae2e7f981c0bdf33ab4dd64d6a302b4d5a"
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
