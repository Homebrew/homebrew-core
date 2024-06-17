require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1291.1.tgz"
  sha256 "739251d6d4262616e2fbfa3c7238d735c663df42e571e421f8310a41d6a8a132"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24f340dd72a5555569cc7158a4ac461bfdf8f4374233bd2341e6de29af8dc59f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24f340dd72a5555569cc7158a4ac461bfdf8f4374233bd2341e6de29af8dc59f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24f340dd72a5555569cc7158a4ac461bfdf8f4374233bd2341e6de29af8dc59f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ab76f42aa0e1ef792b182a292ea01392304f443d5e8f30973b166da21d92cc9"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab76f42aa0e1ef792b182a292ea01392304f443d5e8f30973b166da21d92cc9"
    sha256 cellar: :any_skip_relocation, monterey:       "4ab76f42aa0e1ef792b182a292ea01392304f443d5e8f30973b166da21d92cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a07dde181e9406cfedd983423ff8e7359919bb54b306a7a6a46cb247006cb2fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
