class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.73.9.tgz"
  sha256 "e35f08cf59a0b5c27d8b4adc5890795f89c1051e592db4bea041e57cf5814feb"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f183681d40b3c869ee2039043f06ca534fcfced5c3623bf8ca95b69765eec66e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f183681d40b3c869ee2039043f06ca534fcfced5c3623bf8ca95b69765eec66e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f183681d40b3c869ee2039043f06ca534fcfced5c3623bf8ca95b69765eec66e"
    sha256 cellar: :any_skip_relocation, sonoma:        "924cf267ac95ee594b3e238e1c88bb85c601734ebbf2339390b62c27934dde2b"
    sha256 cellar: :any_skip_relocation, ventura:       "924cf267ac95ee594b3e238e1c88bb85c601734ebbf2339390b62c27934dde2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f183681d40b3c869ee2039043f06ca534fcfced5c3623bf8ca95b69765eec66e"
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
