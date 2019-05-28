require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.65.tgz"
  sha256 "f1ad698508ab93e226bf14fa3aca075aaf64042a973d690d5ed241cf203dd690"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c20a24e996400f5758f38308a0fd1ed4469a9a56d5cd60755880ba916ce0444" => :mojave
    sha256 "f6524773b9b852fef7ced472db45ebcf492a4185119f8d46fe6e370c4879f9ba" => :high_sierra
    sha256 "b736a929c9cd21b756bdea5ba2166f9c48485f0730b531ba886c73b6338feb44" => :sierra
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
