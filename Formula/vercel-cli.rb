require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.17.0.tgz"
  sha256 "f24436f950c52e69d9fc5ffe41a205dbae06fbde8e1e7058af7b94459cad8158"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac97c3681503b656cf163de0745e63487788024eefa1e850ccbc4f3035651d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "035d7eff0445969d7c60ff237710645d82abacf1d6a7ccac5094068fc289d2ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbd0733dd892e539287225a3c947f802b6f6c4254c72f7d9fd59e6445dbcc0c9"
    sha256 cellar: :any_skip_relocation, ventura:        "498cace4c2a890134ae63fe42ed61e819c557af98c66b0fb469e885ad2a8b305"
    sha256 cellar: :any_skip_relocation, monterey:       "1abb262eb714d1f4877bd40ef99054a425b240adfe002f1879d1df5de7369d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fac0797ee076001fd60727fef5bb0c69a0e49dd3c323281a499c77d33a462e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc30e044720fe204b7ce11f039c3f0046ea27e91b78598d69e4bbb7d7cd952d7"
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
