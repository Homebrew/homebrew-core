require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.5.9.tgz"
  sha256 "0288f47ab305550d0f21633a9a487e1de688556229242bf0c86e120d1240e1c4"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/terrahub/latest"
    regex(/"version":\s*?"([^"]+)"/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d58eef3198f6b31645a2917117c6a993fdc4cc9210c1ba094fd3eca7ead44fb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d58eef3198f6b31645a2917117c6a993fdc4cc9210c1ba094fd3eca7ead44fb6"
    sha256 cellar: :any_skip_relocation, monterey:       "340fc28fb08e1437212792e0bbd02220d2af586f6234b326a5bcc6b3274869c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "340fc28fb08e1437212792e0bbd02220d2af586f6234b326a5bcc6b3274869c7"
    sha256 cellar: :any_skip_relocation, catalina:       "340fc28fb08e1437212792e0bbd02220d2af586f6234b326a5bcc6b3274869c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d58eef3198f6b31645a2917117c6a993fdc4cc9210c1ba094fd3eca7ead44fb6"
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
