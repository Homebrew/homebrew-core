class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.3.2.tgz"
  sha256 "c034b5e9ed38c51fe455218e310302c3337d0e13398b90cff9e200688ccbf596"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ecd4dae6863a418c93f0ccd5345d927aecdb19b591e1c14730d5ffd6c64b91b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ecd4dae6863a418c93f0ccd5345d927aecdb19b591e1c14730d5ffd6c64b91b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ecd4dae6863a418c93f0ccd5345d927aecdb19b591e1c14730d5ffd6c64b91b"
    sha256 cellar: :any_skip_relocation, sonoma:        "12b8d003375ab8d1e04e98bc59858ea93f5551d4f21055ea19b8f607a8d1640b"
    sha256 cellar: :any_skip_relocation, ventura:       "12b8d003375ab8d1e04e98bc59858ea93f5551d4f21055ea19b8f607a8d1640b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4e1260df9d3f1d1662ce12d369c9de3c322be8a844be58095b57844752770b"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
