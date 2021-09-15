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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9cd5b24c1b87a231d48df5da617fa8242339c92246c490a5a0ea1a4e7fb9442"
    sha256 cellar: :any_skip_relocation, big_sur:       "2701a88dd0f650440fc3dfd89f5f3a7fc92be873af5d52f9ead161565f890718"
    sha256 cellar: :any_skip_relocation, catalina:      "cc78150685716c025d3ce250560a740adb9c3a31fa18ba77ef9a4e941c0f8ab1"
    sha256 cellar: :any_skip_relocation, mojave:        "1a309ff327dde46de69818a4f4daf2d2a4589e3c0a353830e4b77e862898c85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cad3a9b36145aba080dd2f2ea2fee44464f98707dba6c254ea773298abcf47f"
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
