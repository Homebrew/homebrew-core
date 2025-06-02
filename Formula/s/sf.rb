class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.90.4.tgz"
  sha256 "1dc28f6521e6ea56ddf18332becb1734636049152263ea827ab29b30e58a9eaa"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af3aa10c60e9f1c79f13f85c460c068b38105e3abb93e7809c05942bbc21addb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af3aa10c60e9f1c79f13f85c460c068b38105e3abb93e7809c05942bbc21addb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af3aa10c60e9f1c79f13f85c460c068b38105e3abb93e7809c05942bbc21addb"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc454ae1500edd2f952078e71f61041286b932f5e6b91ae2903f7a9b0697b78e"
    sha256 cellar: :any_skip_relocation, ventura:       "cc454ae1500edd2f952078e71f61041286b932f5e6b91ae2903f7a9b0697b78e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af3aa10c60e9f1c79f13f85c460c068b38105e3abb93e7809c05942bbc21addb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3aa10c60e9f1c79f13f85c460c068b38105e3abb93e7809c05942bbc21addb"
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
