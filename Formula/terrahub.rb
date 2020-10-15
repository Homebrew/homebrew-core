require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.36.tgz"
  sha256 "70fe9fdea7c7c609bf2d77cca32e3f145b7745ed2b3145a6d520d9b04a2accd1"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1004bdd24dd3742533d019d2161dabfb5d92134f30aeb9b7848e996e85d36abe" => :catalina
    sha256 "2c49315f26c3a2d870ae8baab83fe3b8c047b9a897486440862058ac263b8574" => :mojave
    sha256 "40a354750d41019ad17794f2af3d0585092f6df04ddde30af31838c4a8274f2e" => :high_sierra
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
