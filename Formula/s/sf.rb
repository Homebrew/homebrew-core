class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.75.5.tgz"
  sha256 "4682ed4b471998deb6fd7ecbbaea960115468cf8bfa98d842eaad370e2dc5c3a"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb585a91310fb2a29516b6a0dd0aada38ee0c31683b6428c901c52919687c03a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb585a91310fb2a29516b6a0dd0aada38ee0c31683b6428c901c52919687c03a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb585a91310fb2a29516b6a0dd0aada38ee0c31683b6428c901c52919687c03a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fce37c233156229d5ee699979b2ed629bb35048226abe503613394d01b43c311"
    sha256 cellar: :any_skip_relocation, ventura:       "fce37c233156229d5ee699979b2ed629bb35048226abe503613394d01b43c311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb585a91310fb2a29516b6a0dd0aada38ee0c31683b6428c901c52919687c03a"
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
