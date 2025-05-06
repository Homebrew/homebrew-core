class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.86.9.tgz"
  sha256 "6c31d518b5faf55e92e1f29249aba62c714f7cc609bf5ff2f31ab8644436c6d6"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2bcc54e5d61244d7de123f79d5223f662be91a6cdb5bbe6c95f8c8efcd95df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c2bcc54e5d61244d7de123f79d5223f662be91a6cdb5bbe6c95f8c8efcd95df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c2bcc54e5d61244d7de123f79d5223f662be91a6cdb5bbe6c95f8c8efcd95df"
    sha256 cellar: :any_skip_relocation, sonoma:        "90430220c516509faa01760597705e7731a15a4c9dc732d2c0376a252c7ace19"
    sha256 cellar: :any_skip_relocation, ventura:       "90430220c516509faa01760597705e7731a15a4c9dc732d2c0376a252c7ace19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c2bcc54e5d61244d7de123f79d5223f662be91a6cdb5bbe6c95f8c8efcd95df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c2bcc54e5d61244d7de123f79d5223f662be91a6cdb5bbe6c95f8c8efcd95df"
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
