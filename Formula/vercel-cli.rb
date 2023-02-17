require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.2.tgz"
  sha256 "0d102ec7f5f00fe25b022a553a326732668a7916ff89043e3e27d54c68bbcef4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b565d1f6bf2133944dafab05429de7012807b1f916989b66be60be8afa7482db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3179002698dcb8908dfc27893837cda60b418d9ba55c73317ca6e02f8de58a2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "567392784948a9842dcc0e413586bc9d3b09ac7276cb9ec8da57bb517b76a741"
    sha256 cellar: :any_skip_relocation, ventura:        "9fa0414f81d0fb9fb67ae67f459dede7c9bdb268669159f96f0ed8db37c76a27"
    sha256 cellar: :any_skip_relocation, monterey:       "c596c648dc015fc067ef3b7170adf9126b7a7d47d6b54f91131a0d84d7ce7286"
    sha256 cellar: :any_skip_relocation, big_sur:        "e47bd9d0adaf0024f09b007efe212696ff910f4367fc63584e79b63d6926ac82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb69bacd97a33091eaffad72fbbbb9c058f9600281cc838963948c070d22ddc"
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
