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
    sha256 "7d805e0e8839f6bc993e43a7541cfab45ad0605b2abc05e81f0779c6daaffcc8" => :big_sur
    sha256 "b264b8042c7c88fb6e592e92950c06665ee4f61d09417c48a44d1c9fd0ae750d" => :arm64_big_sur
    sha256 "4b896236b4b7ad2eae072621d8edd42b5d6fba522d62f7ab197190e9abfd4eab" => :catalina
    sha256 "26c0bec7fc55522db10c39dc1cfd83df304b6e6affa3d34d716b875d3f0970d2" => :mojave
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
