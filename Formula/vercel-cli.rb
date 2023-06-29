require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.0.1.tgz"
  sha256 "de7714c4b29bcc13f478e1f6f15abac30d6ae63909ea5d605b72ae9b1a02f075"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6dc3017366d0f635b64b4ea12a6522cdb16db9be407010f40fb8a04091d981c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8391b89d4aa11d369a799e05e742c81f843cd53f49e7da685bac33c23a23f6eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5acc7083b013810aa3bba6480c653de64dfe0aa5ae6f68fb9498e069e5511d16"
    sha256 cellar: :any_skip_relocation, ventura:        "aab6a6ff0a76fbfa3fbf5868d80bd070468d9f4c2dbbe4308c3c8b2213c1ec06"
    sha256 cellar: :any_skip_relocation, monterey:       "85c8f36e9d303caed45fe2e9c9f338d35d38d632e36176333454ba9233925220"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdcb64827e1234e9900e66a396691a9d92191a87069a0c2cc827af1330486814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3460eb52b2801502b27b9b682c59d807e44feb54f466baec54b96d757a04b255"
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
