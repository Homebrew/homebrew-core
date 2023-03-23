require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.18.1.tgz"
  sha256 "6e5b46dbdda60807deea8df0416bb72f4ed62fc23f0dab18674fe7434ee2e9e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b934358b4dce8bc8144bb4b2f945abfb080db5eca1e5fd8bd4c8476e08ea14a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a9856a622d9606949c7424764604f25661aca15a647d35366160b5b0bfdffeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69101db5c569491d0baca8f094878f0f79ac610c23e3de6db3e265f14939cea9"
    sha256 cellar: :any_skip_relocation, ventura:        "2c186aa69c3afb2e26d3050dc97cd0a1dee9007b41b26a4419755d5bc6b50ef9"
    sha256 cellar: :any_skip_relocation, monterey:       "12fc49d8353be9ed031aababc1a93dd9e6dfd2a46217d582d1684e52499f67f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5959f029fbccf4fa15da654acad5493f4bd329c79ee9ae9a3adce56cb4f7cf0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c0536b181ae2dce916f6bd5b28b357d6cefca583294b0481ce77f4eea460801"
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
