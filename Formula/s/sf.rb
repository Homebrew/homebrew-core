class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.85.7.tgz"
  sha256 "dcfa4922b22f6a8692a6c08fd8cb023ca344e86d1718a600962b86675524a46f"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1b75e3ae3a389d7ac7aa0f7e007a605154c47028112c3e87d0c0643a50f2e4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b75e3ae3a389d7ac7aa0f7e007a605154c47028112c3e87d0c0643a50f2e4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1b75e3ae3a389d7ac7aa0f7e007a605154c47028112c3e87d0c0643a50f2e4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cf47ff2b85ff24ace810d0bcf1d2432fdc43f78e92944820ee69bcce7239eed"
    sha256 cellar: :any_skip_relocation, ventura:       "3cf47ff2b85ff24ace810d0bcf1d2432fdc43f78e92944820ee69bcce7239eed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b75e3ae3a389d7ac7aa0f7e007a605154c47028112c3e87d0c0643a50f2e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b75e3ae3a389d7ac7aa0f7e007a605154c47028112c3e87d0c0643a50f2e4f"
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
