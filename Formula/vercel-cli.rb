require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.18.5.tgz"
  sha256 "f5c7cb01fdee20491ee887d0d841277376fd2e56de96b5e228d5cf812162a502"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64fb6165362c4beee442402f6365aa7a23021355698b4b2e04941d5340329aeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c72de97645c603bd8a5f6ef1fa8ae76b0031fdef5a75b13ba7558ca191ddc74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb122d63d891f8060dbaead8070547df1987769837a6f98b76c97e2fa9d37a90"
    sha256 cellar: :any_skip_relocation, ventura:        "11ba63b16aed59acb0533425bb6ee88ef78be296ca7e1039b4fd491ed933327c"
    sha256 cellar: :any_skip_relocation, monterey:       "8d32b60445ca05470b038f47bf70615ae8815389cb194257824d5e61c844500f"
    sha256 cellar: :any_skip_relocation, big_sur:        "79663cb761bb1d23fcad32475cd44811aa1560703493b35422c06c9a19064de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d352a7b17b0cecd9ec726ba90fc5c0271f1782311d653ccfdc8fb67db597757b"
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
