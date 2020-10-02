require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.29.tgz"
  sha256 "873af9f4d2c5dc9f7c82163a5a38a11c76c7653a5c1c62fedc586956f23e9c74"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a39fbab6315372412a7a26b02ee9e7365e2ed1f1c52359c943f94065ee236cd3" => :catalina
    sha256 "16253bbcc02bd5c9566ca7fc17768bc5251eed1c921b5d42269464d24635ecb3" => :mojave
    sha256 "88cd7c7ce98a571424ec39f1f4ccc53200d4be39beb4629d293ec99f57ca5f4d" => :high_sierra
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
