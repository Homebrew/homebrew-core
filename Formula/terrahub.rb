require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.15.tgz"
  sha256 "67da9dc9ec83a67d128de0f6655513fde06ac7565e835ba69a1139660b075ae0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb454f04e48ee211a313d5db0ddb4ca38e68d7dfb3d1f2f0ed52f5770265c20b" => :catalina
    sha256 "b3c538fb120956a2c52a57cca97245a7883dcdb90825546c4fafd13df19c5b59" => :mojave
    sha256 "6244994123636c2b789c4f572fc3df55ceb7b758c231bf46dbec107a6ec384c3" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".terrahub.yml").write <<~EOF
      project:
        name: terrahub-demo
        code: abcd1234
      vpc_component:
        name: vpc
        root: ./vpc
      subnet_component:
        name: subnet
        root: ./subnet
    EOF
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
