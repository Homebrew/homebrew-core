require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.52.tgz"
  sha256 "b4f2e386fc4e12ce402c2ed9bf0bea89cb03fb17cbc17ab9db846280d4187098"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "709d2667924b158124121de0de3805bc2abffa7a8f541416481cecc7de78b7fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "709d2667924b158124121de0de3805bc2abffa7a8f541416481cecc7de78b7fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "709d2667924b158124121de0de3805bc2abffa7a8f541416481cecc7de78b7fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "acd0b7f6c3266eed36e28cdeb684dba38602d559f7048f1fd4d90136aee2a98a"
    sha256 cellar: :any_skip_relocation, ventura:        "acd0b7f6c3266eed36e28cdeb684dba38602d559f7048f1fd4d90136aee2a98a"
    sha256 cellar: :any_skip_relocation, monterey:       "acd0b7f6c3266eed36e28cdeb684dba38602d559f7048f1fd4d90136aee2a98a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709d2667924b158124121de0de3805bc2abffa7a8f541416481cecc7de78b7fa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end
