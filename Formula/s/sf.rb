class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.96.4.tgz"
  sha256 "5f5fe576badca0cb776f40963c9999f8f3ec0019273858f1b3a39d2e630f2e4f"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58f945db6d1925cb81af120e5ffa3b7c746d7f0617d53f849629195b8052b69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f58f945db6d1925cb81af120e5ffa3b7c746d7f0617d53f849629195b8052b69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f58f945db6d1925cb81af120e5ffa3b7c746d7f0617d53f849629195b8052b69"
    sha256 cellar: :any_skip_relocation, sonoma:        "be12fa531429cf22cd3a0d5ab68e957279f13d8a9d05626a5f281a4dc9d3dc36"
    sha256 cellar: :any_skip_relocation, ventura:       "be12fa531429cf22cd3a0d5ab68e957279f13d8a9d05626a5f281a4dc9d3dc36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1944b0e53e89a8ef3e2d520dd50eecefc82aa83c0608c7539e5b4f04fa33a407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1944b0e53e89a8ef3e2d520dd50eecefc82aa83c0608c7539e5b4f04fa33a407"
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
