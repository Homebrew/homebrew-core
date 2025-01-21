class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.72.21.tgz"
  sha256 "3eb159ff592ee46843832ff00e6962db1a543bc24147112a2e0f75e2b419cd75"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74cf53111df0c8b13352b3a00d07d9aa5e35d34c39b49253ad439159b31b425d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74cf53111df0c8b13352b3a00d07d9aa5e35d34c39b49253ad439159b31b425d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74cf53111df0c8b13352b3a00d07d9aa5e35d34c39b49253ad439159b31b425d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ba6a470629eb566c5d5279d5d5f87d5ba5bef87f96e5dc46630d7d73d46bafd"
    sha256 cellar: :any_skip_relocation, ventura:       "4ba6a470629eb566c5d5279d5d5f87d5ba5bef87f96e5dc46630d7d73d46bafd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74cf53111df0c8b13352b3a00d07d9aa5e35d34c39b49253ad439159b31b425d"
  end

  depends_on "node"

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
