class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.83.7.tgz"
  sha256 "f22bbe5587e07017e3b0d3bac01a2c8c1524b02ca5c68411faf135ca2c85ab58"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d702c85163724cb8b92c4194ce0c1d1527d5075417e43ce80f40a70d440526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d702c85163724cb8b92c4194ce0c1d1527d5075417e43ce80f40a70d440526"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77d702c85163724cb8b92c4194ce0c1d1527d5075417e43ce80f40a70d440526"
    sha256 cellar: :any_skip_relocation, sonoma:        "104e654818c910b0f7d8218eb09aa9454764f261726191a7a414312d6475c2ed"
    sha256 cellar: :any_skip_relocation, ventura:       "104e654818c910b0f7d8218eb09aa9454764f261726191a7a414312d6475c2ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d702c85163724cb8b92c4194ce0c1d1527d5075417e43ce80f40a70d440526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d702c85163724cb8b92c4194ce0c1d1527d5075417e43ce80f40a70d440526"
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
