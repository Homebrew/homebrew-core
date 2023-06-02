require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-30.1.1.tgz"
  sha256 "acb90bd3e3e8e91ec99d12b1407b82348419cfcc8eddb790d91d81fc4a6fe4f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0357e7ca206441c681eccbb07476ae2507d9f821d163de33365f70f1ed9add65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "702edaadf1ddc93c971c9b2cec4f2b3d4e1e5e881c78cad08c81b1be8e604b60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d43f66ae6ae5edc213be584940e7ac7fadfc2e7e0133c43ebea7f1e2a1eb578b"
    sha256 cellar: :any_skip_relocation, ventura:        "6cc88817795ff6e3aa2a10d24cc73bc196943ce9d562ccbf063f1533b47f7f53"
    sha256 cellar: :any_skip_relocation, monterey:       "77c45ca78ff2aa7e74f7fbc7369603897908b6cd17a7a222da7b390937d4fc7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "46bda4531cbf471a7dbc6ee99fc271e6c10183b0a56fed796a7a6387e60be76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fe7b91375d891ab5e062e905bf14dbfac8a163844bb2d5602ca1b1ab5dd31ee"
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
