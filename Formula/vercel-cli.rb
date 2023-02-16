require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.1.tgz"
  sha256 "bfc58ae8061e1805f99c753cfe0219ea69249913aa46454690e8e5bf2080cdcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50e269387c1db3f3318daf257b67bb94ef30ec339e1355e47b938c1175a04b04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "343e45d73311730d57f9ddf2d5d5e95f08a276d6bbbfdf938cee532eee04bc63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d22df9717a44b2a4b531c30ba5b39c9b04611e98d8ce86d941395414f9f60d8"
    sha256 cellar: :any_skip_relocation, ventura:        "7d098343335c2c26462fcf0008f08453c558a243492aa7aeed0e784690dd589f"
    sha256 cellar: :any_skip_relocation, monterey:       "19fadaddce4e4fa96504a4be2dd961c2496410ddc29e972a829bc41850d9bbae"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae0021fd9e4dd28d1bc0f4187c438db039e8ec362c84794340e02e137753f9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83e8da8c91eb6fca5338cbc1db27a5f102d2eb5c73d7f35fbfee1f66711aaf4e"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
