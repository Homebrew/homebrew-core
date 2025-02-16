class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.76.7.tgz"
  sha256 "2c8f39f0c2121c2c90d92da82ed56d675de46df2d6afef98d207d40df9e9c4d2"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "844695253b9085de6be5e0d9b17c96e6cdda25248fc325d4dc62610b7a54cc1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844695253b9085de6be5e0d9b17c96e6cdda25248fc325d4dc62610b7a54cc1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "844695253b9085de6be5e0d9b17c96e6cdda25248fc325d4dc62610b7a54cc1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3d282a59cd762117cca08bfdab4170ff3121207ad9c949646d52fdf15b28038"
    sha256 cellar: :any_skip_relocation, ventura:       "b3d282a59cd762117cca08bfdab4170ff3121207ad9c949646d52fdf15b28038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "844695253b9085de6be5e0d9b17c96e6cdda25248fc325d4dc62610b7a54cc1d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"sf", "project", "generate", "-n", "projectname", "-t", "empty"
    assert_path_exists testpath/"projectname"
    assert_path_exists testpath/"projectname/config/project-scratch-def.json"
    assert_path_exists testpath/"projectname/README.md"
    assert_path_exists testpath/"projectname/sfdx-project.json"
    assert_path_exists testpath/"projectname/.forceignore"
  end
end
