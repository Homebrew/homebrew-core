class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.84.6.tgz"
  sha256 "306c2ba4d8a908bb4aeeebedf207e4452e8beedffc6f92b530fcf1010b447f90"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d2e33693858ba9a47276142cf84ac091766bee72e6a18c7c417b07caa1cd7d"
    sha256 cellar: :any_skip_relocation, ventura:       "70d2e33693858ba9a47276142cf84ac091766bee72e6a18c7c417b07caa1cd7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763885acc4c6e34b117bcadf864ee20d4502a8fa990096c9c2648df51c1e06a3"
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
