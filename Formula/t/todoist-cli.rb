class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.2.1.tgz"
  sha256 "e88c79ae29cf0bd5e5ee8fd949cf3bf2152104dca1c308218a3afb5e92578ad9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e38a49562ca154b26e23fb2e349bb9da15ace79d199c858b72c44e8a218543ed"
    sha256 cellar: :any,                 arm64_sequoia: "e38a49562ca154b26e23fb2e349bb9da15ace79d199c858b72c44e8a218543ed"
    sha256 cellar: :any,                 arm64_sonoma:  "e38a49562ca154b26e23fb2e349bb9da15ace79d199c858b72c44e8a218543ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb14ed300a4296240ee6a1ec8b06950a0122e71b388effec180eeb55a93cf1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8014e336c0b32952e244f10e2899b2bb596adf64bec767f24516471b595ed39"
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
