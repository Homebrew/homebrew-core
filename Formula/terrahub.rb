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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "789268e0bba0906de4628714931d067d6fa90c8cd5a3f04987546227aa8490fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "789268e0bba0906de4628714931d067d6fa90c8cd5a3f04987546227aa8490fe"
    sha256 cellar: :any_skip_relocation, monterey:       "14e33898a766960658e4c91ab8f86b95259593ee7002a08fc1a9ec7a4383b940"
    sha256 cellar: :any_skip_relocation, big_sur:        "14e33898a766960658e4c91ab8f86b95259593ee7002a08fc1a9ec7a4383b940"
    sha256 cellar: :any_skip_relocation, catalina:       "14e33898a766960658e4c91ab8f86b95259593ee7002a08fc1a9ec7a4383b940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789268e0bba0906de4628714931d067d6fa90c8cd5a3f04987546227aa8490fe"
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
