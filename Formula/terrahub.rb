require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.5.8.tgz"
  sha256 "a1b98f21b4a95306ef9e74d59c6499fd746fee9dc004aed3b82dd894cec2e93f"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/terrahub/latest"
    regex(/"version":\s*?"([^"]+)"/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eb2821ae0075619bc476a56836b3f4b93d7b91ace86470143d0ce00fa05b025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eb2821ae0075619bc476a56836b3f4b93d7b91ace86470143d0ce00fa05b025"
    sha256 cellar: :any_skip_relocation, monterey:       "5c95dc4d14eae7f22b99f69ce74c549f5bcb6d7c24ccc8d779556b06b4c0e2e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c95dc4d14eae7f22b99f69ce74c549f5bcb6d7c24ccc8d779556b06b4c0e2e7"
    sha256 cellar: :any_skip_relocation, catalina:       "5c95dc4d14eae7f22b99f69ce74c549f5bcb6d7c24ccc8d779556b06b4c0e2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb2821ae0075619bc476a56836b3f4b93d7b91ace86470143d0ce00fa05b025"
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
