require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.5.2.tgz"
  sha256 "afb6a0d572a56e078f8b55d22f69e9743d12530a9a51d4d4da5a5073785bca95"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/terrahub/latest"
    regex(/"version":\s*?"([^"]+)"/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e48badba557dfcda2234072e1bd141d4450c8507ad60d55df541165fac7178d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "18623447b5df13ecb6f6cca5dd274113932e1f5c5da06112ead7aacca4bca735"
    sha256 cellar: :any_skip_relocation, catalina:      "b522427ec32fa9d6bdd17c82c594958f3be7636e859cb80b483843e89b65eac2"
    sha256 cellar: :any_skip_relocation, mojave:        "2bb024c5eb4877df4d91ef86b01b42694daa449eb1aeed7d7ce263e6e66264f1"
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
