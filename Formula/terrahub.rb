require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.46.tgz"
  sha256 "1b201cc86427297bc4e2ef6e05b7906f33dc50c14482f17b8a488a138a74127c"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c6db2371894dbf89d9b3d231ce39279fa36b3f41c90668d8edcb3f61cbad7daf" => :big_sur
    sha256 "145e3f988531b8c835c3c8427839525280d4348935ed8056a79c507437945c95" => :arm64_big_sur
    sha256 "531571fdfafece71b4762f5348892abd535fbd7d1cd92a848dd30f62fe84202c" => :catalina
    sha256 "bfa6c5a7cc985f29cb4903b6cc26279b5fd0ae2fd7cd7b4bc09d84c4e3bba4c4" => :mojave
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
