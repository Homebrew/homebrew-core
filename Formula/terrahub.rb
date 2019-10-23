require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.3.18.tgz"
  sha256 "80b3c89791e843116abc289e063a1476586905135988def9ef4cc0d98fa0615e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8b9647275016526558c5c82c69513f0e0ba796b69e711425595f5f35cbc96af" => :catalina
    sha256 "cdfd1c17a37ac70d13d1447ae175b55b0e9493618d6acf6e39a58e42b25861b8" => :mojave
    sha256 "0c3df5b48eee782d2fe1b82f27c8cbdf25e1dd06c1fd588226f7698a915d30e0" => :high_sierra
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
