require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.3.6.tgz"
  sha256 "cc97e9e1e40e897e0b25454822437b7d4d8a6ec6ba730b06b071f3f7ff00b80c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9faa5f5273f36e012c8bdbb00cf2921935c3e9f63c396cbb4092a05fd8c1ae97" => :mojave
    sha256 "ac3da5e30771111cac05762d35a4c20a3f0c02b5ae34cb459ec6286b1262c7fd" => :high_sierra
    sha256 "750987f3e5f0f9ae9e499049a32ce252ec727817b79cad38d021c1d446944602" => :sierra
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
