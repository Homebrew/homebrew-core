require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.5.5.tgz"
  sha256 "b24521b4f5542d50a900eb64e75d5d796d5cc2ccab76090af50cd4be15adfafc"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/terrahub/latest"
    regex(/"version":\s*?"([^"]+)"/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06c1650e2da7ea8fbde4037d522497d5f5a82e9565983610253723140e43df09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1258000ba0fcea8aacae546c1623b98858cbcdcf3bef406a58271134bb4b3fe6"
    sha256 cellar: :any_skip_relocation, monterey:       "795adda61afd8b014682543f6272e14bf269fa91890c33bd0b182f9bfcd5cb3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c32fed79f29e9f9dfc5ca06ff95fee401fc12be011e424102bb7cdd1fadaeb92"
    sha256 cellar: :any_skip_relocation, catalina:       "c32fed79f29e9f9dfc5ca06ff95fee401fc12be011e424102bb7cdd1fadaeb92"
    sha256 cellar: :any_skip_relocation, mojave:         "c32fed79f29e9f9dfc5ca06ff95fee401fc12be011e424102bb7cdd1fadaeb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1258000ba0fcea8aacae546c1623b98858cbcdcf3bef406a58271134bb4b3fe6"
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
