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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f1f81b841d746720164e8a465c7a9cb4f83255590bafb7f348d2682f460c009"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a7125738ab3e6043e4dc98eb60b2d702491e1f34d9fe67f727d695bd3c3230c"
    sha256 cellar: :any_skip_relocation, catalina:      "6a7125738ab3e6043e4dc98eb60b2d702491e1f34d9fe67f727d695bd3c3230c"
    sha256 cellar: :any_skip_relocation, mojave:        "6a7125738ab3e6043e4dc98eb60b2d702491e1f34d9fe67f727d695bd3c3230c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f1f81b841d746720164e8a465c7a9cb4f83255590bafb7f348d2682f460c009"
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
