class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.62.6.tgz"
  sha256 "60306ae6888790c98f1dca18036a21a6cf3a61ddbfe62957ac4d3881fd959ef1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14ff2a892709ac82d7a4014554625c5932709a99b4f648895b4d5e6191d38afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14ff2a892709ac82d7a4014554625c5932709a99b4f648895b4d5e6191d38afa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14ff2a892709ac82d7a4014554625c5932709a99b4f648895b4d5e6191d38afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "76274fdf218d9258908732ae44fea274f9a7d41328575eb82bb766e14823a77a"
    sha256 cellar: :any_skip_relocation, ventura:       "76274fdf218d9258908732ae44fea274f9a7d41328575eb82bb766e14823a77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ff2a892709ac82d7a4014554625c5932709a99b4f648895b4d5e6191d38afa"
  end

  depends_on "node@20"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"sf", "project", "generate", "-n", "projectname", "-t", "empty"
    assert_predicate testpath/"projectname", :exist?
    assert_predicate testpath/"projectname/config/project-scratch-def.json", :exist?
    assert_predicate testpath/"projectname/README.md", :exist?
    assert_predicate testpath/"projectname/sfdx-project.json", :exist?
    assert_predicate testpath/"projectname/.forceignore", :exist?
  end
end
