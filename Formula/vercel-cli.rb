require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-30.2.1.tgz"
  sha256 "b11730a863f08b57d9858a5714b121d3aa9b3f1ed3463f8081051f7341aeee43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b970fa787af3cfac08d816c3f0d6424bab731494b9d749e29bd5bbeeb95b293e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f8d797453485a1fc875c65dff5eb4918366dcf7a85ceb5e56ef330f5369344b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e20bf9745c227fb1c80bb53fd7123332e4437771883a5312078d142efd898d80"
    sha256 cellar: :any_skip_relocation, ventura:        "6eb514f7b85b1af4c7d47a889ba54665ea6df7db0a998de08681b26173402d37"
    sha256 cellar: :any_skip_relocation, monterey:       "d0371d012bf8f6283774718d85c47244fb9df092528cf462de189c3079b1a903"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef9a0e10c6bbfcf170b99ee3a8b9436f0bcc09cdf674f8b060ef05866fe6cb80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b179f55eb2ff142cfd5b9fb82f0a33071deef9b471c1ccfc564cfa07e70623"
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
