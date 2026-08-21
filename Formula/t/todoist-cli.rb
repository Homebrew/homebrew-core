class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.2.3.tgz"
  sha256 "b167c55b3ce715fb1b37b3caf3f34d7145af18631c37ab35d84a180e7c17f1a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "505dd50870c97a5f5704759f6419fe51ff7ee7bf082e103eb68511687838a780"
    sha256 cellar: :any,                 arm64_sequoia: "505dd50870c97a5f5704759f6419fe51ff7ee7bf082e103eb68511687838a780"
    sha256 cellar: :any,                 arm64_sonoma:  "505dd50870c97a5f5704759f6419fe51ff7ee7bf082e103eb68511687838a780"
    sha256 cellar: :any,                 sonoma:        "393a5098b353d1036d3241641cfd33aadfce5728e321f836a558c75bca006335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50cf6fb50a391fa3476436ca92810cb917d8085ed9655eee0c86635d06b7d84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f0e260680ed64ae1cda24b7fa07c01292804876c55279b237a8fca1b2d0a80e"
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
