require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.3.6.tgz"
  sha256 "cc97e9e1e40e897e0b25454822437b7d4d8a6ec6ba730b06b071f3f7ff00b80c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffae35ae60ef8aa6e06eae7ed4371287bc01c53770cb713d37000b70c9d9b430" => :mojave
    sha256 "fb8464556f05db9d9f14b342a5ab24cd9595aed39644820b69789daf3b1ca492" => :high_sierra
    sha256 "f4a8ca92c0d72f4b30d2133b3eeda60df32e69ba3daea79c25b3455e703c45b7" => :sierra
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
