require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.12.tgz"
  sha256 "8f6772bd22c279dbfc35fc6670f0680b1be53aaad32ae317e6d48794357e3c8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8ca24532d2d42acb353096e3027ce152f860516978bcc240c23ab759f84ef22" => :catalina
    sha256 "3a693271311ece45eec33e52f30cb077f61c1dc5cb21bc81e21c30b025f6c514" => :mojave
    sha256 "cc1c43c7c96fa55c85896012e45c174d8b262bcc2184c58a84f564c63ef9b89a" => :high_sierra
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
