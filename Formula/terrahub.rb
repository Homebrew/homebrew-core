require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.33.tgz"
  sha256 "22ae39c172b0da281d150fa2d49399a4559509f655037a2776f9fa8edd289728"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0e6a87ad033e2c2664d8a358dbfcb9a5625385a575a5407011edf45497948c74" => :catalina
    sha256 "cd330be5ec1274e46eb696fbd080e4e1709e275bd772c4161608e9e039f9b57e" => :mojave
    sha256 "d94c6a19692e49720bde3dae78dea34e3c27a1e8245aadd1da1849e19944142e" => :high_sierra
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
