require "language/node"

class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://registry.npmjs.org/@railway/cli/-/cli-1.8.4.tgz"
  sha256 "b057db0b76df651e982f79928d9f1f8dd37c6fce91995e41c56bf8ea6559b11c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43c4b5d59c590411305e3f4b337c258a84d79da42f50977d03f28de553298bde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43c4b5d59c590411305e3f4b337c258a84d79da42f50977d03f28de553298bde"
    sha256 cellar: :any_skip_relocation, monterey:       "e59249e679562083c725649e857aabeacb88d882777c97c9fe296a4a8f7837e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e59249e679562083c725649e857aabeacb88d882777c97c9fe296a4a8f7837e6"
    sha256 cellar: :any_skip_relocation, catalina:       "e59249e679562083c725649e857aabeacb88d882777c97c9fe296a4a8f7837e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97932383592f5f244e75c84e9cdda9ce5e3171358b45518895c62afd6dd03b89"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Install shell completions
    output = Utils.safe_popen_read(bin/"railway", "completion", "bash")
    (bash_completion/"railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "zsh")
    (zsh_completion/"_railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "fish")
    (fish_completion/"railway.fish").write output
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end
