class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.0.0.tgz"
  sha256 "cdb9da4489e932c28a42440e0149f3493922e01191ea1b59ffb98fd3f3846d7e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "658a5c45a546adcc47040f5e93afce6350fb9cff4e19b012cc0f5eea2391e2b3"
    sha256 cellar: :any,                 arm64_sequoia: "658a5c45a546adcc47040f5e93afce6350fb9cff4e19b012cc0f5eea2391e2b3"
    sha256 cellar: :any,                 arm64_sonoma:  "658a5c45a546adcc47040f5e93afce6350fb9cff4e19b012cc0f5eea2391e2b3"
    sha256 cellar: :any,                 sonoma:        "a83581a6de17e0024e6c72451600408ef759cef228c45692054ef7d432bf7be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d1108efae215b6ec032cc40cc13d6d9a9ea37a0acf3509766960871429fbc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d603383bba0be1815803a1bbf89e2995d512b4af8719ce5c320f17fd81175e"
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
