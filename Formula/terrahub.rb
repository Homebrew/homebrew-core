require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.45.tgz"
  sha256 "6d3a9f4e26b60c4bbe9b6621d94553e90f91de8009d33b13118d32a8e42cce08"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cc43b7a60a4b4e3e9ab212b60a8f6f79d1dda07b0324f566c53b62a91a25a0b1" => :big_sur
    sha256 "38db019ecbb50f5d7f38f8a610cc99f25c3c5c38c53901065223cb5f9b27eedc" => :arm64_big_sur
    sha256 "53d9a273e958a975c4fa6f655382b71d35ca5ce46191c608a7fe41f6b3841ae4" => :catalina
    sha256 "f4d624a41241a5f9736a4495092b19a2b71a17ca87312ae8676571654d6355bc" => :mojave
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
