class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.73.0.tgz"
  sha256 "414b4b24320ea36dea48554695e6c1fa360cac530382916e5ab5c8a04c52558c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d92bac130d90e8a5115d7f784a3a44b646f232bd892f58daf28c11e2fbfc2bd0"
    sha256 cellar: :any,                 arm64_sequoia: "c282269084a993c5ced4979f70e2296bdce61341802ab64d8fd0380907aa48ff"
    sha256 cellar: :any,                 arm64_sonoma:  "c282269084a993c5ced4979f70e2296bdce61341802ab64d8fd0380907aa48ff"
    sha256 cellar: :any,                 sonoma:        "2223b9882e1b5b24b7a4c5e55e1bdea03020130cb1cf121e55de5f1c488ae2ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431d7686b92ebaf38622baf1e90a5897c2258cd735c488fb4184e2d653a6575a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd181c61b18dc4c1b262f93d864b5b8790d066fccfe325854e8b3ba6ab6e2b3e"
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
