require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.83.tgz"
  sha256 "dc2d21af9cad4ff487a8dd095ae4b5bbe2f8818079d39d574cc954e225d30f71"

  bottle do
    cellar :any_skip_relocation
    sha256 "2697c5604545e8ec833c391611565c61346acb180c85521ecf5b9d5bb792ca64" => :mojave
    sha256 "28c4d595015fdf5605b34e77c430f9487421ad12194d1263260e6ca70e1400a4" => :high_sierra
    sha256 "f5860a59a7cdc6dec7c16e7a019041ac949e27e1b875dc11f9f4b97c8b8659d2" => :sierra
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
