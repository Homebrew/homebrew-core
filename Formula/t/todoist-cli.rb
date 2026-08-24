class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.3.0.tgz"
  sha256 "560c234ac157d053b6e06e23e1186a32b4e5e0cfd1afdc1ea477a60a21b61051"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06e66a751240f57f900d89b1e0aaa00333e2662654a4a9f0e0bbb48e8df77cf9"
    sha256 cellar: :any,                 arm64_sequoia: "06e66a751240f57f900d89b1e0aaa00333e2662654a4a9f0e0bbb48e8df77cf9"
    sha256 cellar: :any,                 arm64_sonoma:  "06e66a751240f57f900d89b1e0aaa00333e2662654a4a9f0e0bbb48e8df77cf9"
    sha256 cellar: :any,                 sonoma:        "8263910ae9c0166867c87f5a1ed346e76a39617a4fcaee57f1ef40b63af90736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50acb1eb1aac12d495e1499b7b35c3e0d867d448777ac443fa18981020d1d799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e10dec54919a67f2bf8bf3820682b36b9e3884b956460d6773cd5f1e44b02c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end
