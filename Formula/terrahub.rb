require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.44.tgz"
  sha256 "130283f0ce51e3e8663fd8ca60df6b0398d5daaaac82aba8a0e2496485705d06"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1cd72770f837c212e30b2e48df221a12a3eb6167e09907fb1ab6c36a852cf3ca" => :big_sur
    sha256 "9b94bf50b9793d8bdcc86115345f5612791460f3758b06d6010211d76b3b313c" => :arm64_big_sur
    sha256 "629b0c9c20568ee806492ac3f68bb2651ae0b8719cc6b28730a37ec048e0cc0b" => :catalina
    sha256 "df37471c1563b70c61c0ce05e2504ac72df23bcc08cc25d1b71166fd568fe56f" => :mojave
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
