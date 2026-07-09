class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.76.1.tgz"
  sha256 "3374e22ffc3a9b687dfb7adfeb7c384f7d788aa637ef2d5be7a3c82c77d16fbb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e768f037d25f0346f805c54eaedfe699a93e4c89467c4fd7697613b44f8bdd2"
    sha256 cellar: :any,                 arm64_sequoia: "992c04c7489265ea8d42a04d83046351e1ccc714f6462cc3859359a76cb28615"
    sha256 cellar: :any,                 arm64_sonoma:  "992c04c7489265ea8d42a04d83046351e1ccc714f6462cc3859359a76cb28615"
    sha256 cellar: :any,                 sonoma:        "c6d4ecd12b34c5bdccdf876efa53a2dd38a91ae7e688f1a7db0abe07508c3604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592fac7ba2105c12c7fa8f2acc06ae99d758ec9f25f52854dc9fc4d29a289220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05a960b5990c726c7e715f23a41e33740c7ac526c1912b60645887fe4bbd9898"
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
