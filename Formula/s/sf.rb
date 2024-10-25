class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.65.0.tgz"
  sha256 "bbf5a414f8acd5af97b11e05a0266bf3651ba5857563b8af71ff80f6e6c2a24a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e60f79f0c427185c32966d48b15eab67988408bdc3d775652cff3ee61a18e215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e60f79f0c427185c32966d48b15eab67988408bdc3d775652cff3ee61a18e215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e60f79f0c427185c32966d48b15eab67988408bdc3d775652cff3ee61a18e215"
    sha256 cellar: :any_skip_relocation, sonoma:        "f146e16cf46b17f06e276c9e2ac64c0355e0f0b1b24f08682af438c3bb7aad50"
    sha256 cellar: :any_skip_relocation, ventura:       "f146e16cf46b17f06e276c9e2ac64c0355e0f0b1b24f08682af438c3bb7aad50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e60f79f0c427185c32966d48b15eab67988408bdc3d775652cff3ee61a18e215"
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
