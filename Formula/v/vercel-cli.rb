require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.0.1.tgz"
  sha256 "5bf233e149b70c5b24252e37864255cf81cb94cd4234cf22177cc83891b6dff0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "412923197e175cfd658821b008c562b30fadec0e978f172196c5440ac6df9d1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "412923197e175cfd658821b008c562b30fadec0e978f172196c5440ac6df9d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "412923197e175cfd658821b008c562b30fadec0e978f172196c5440ac6df9d1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f310e74f3031807b123daf0135f1ac0981234a4141d7b972965318c61586755e"
    sha256 cellar: :any_skip_relocation, ventura:        "f310e74f3031807b123daf0135f1ac0981234a4141d7b972965318c61586755e"
    sha256 cellar: :any_skip_relocation, monterey:       "f310e74f3031807b123daf0135f1ac0981234a4141d7b972965318c61586755e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a91517219c427f1e1c7c1b5739654f8215e510be8863794b5adba0e2c707d3"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
