require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool (open source)"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.3.tgz"
  sha256 "1c247636fffecbf5871d3aa766c154d31eface3f1062a7e46f934e73e24bc6f9"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terrahub --version")
  end
end
