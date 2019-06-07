require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.74.tgz"
  sha256 "5206b8c9d7aeb5924719b67450ec0d2724905749c7e6968973908f00fc1562f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "731e7bdf877210157a6580c72b61d116b9935da1f7693726655759bf92efefd8" => :mojave
    sha256 "40ef9ad8e625efdb93b56b059b1a4c1a75e767128d7863be57b07641ecbad439" => :high_sierra
    sha256 "bfa0260c4d16c51f36ce04dc44fe979400f12f550a11447c11b0bff744502768" => :sierra
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
