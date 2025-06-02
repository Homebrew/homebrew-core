class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-42.3.0.tgz"
  sha256 "9c3ef9b557322ed6a8e39408456947f34f03c33f6712ae5eb28719bac00824ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df30b6cdcb53b954834be2beab81b1ba0684a878d9e7441f488d183b3d617373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df30b6cdcb53b954834be2beab81b1ba0684a878d9e7441f488d183b3d617373"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df30b6cdcb53b954834be2beab81b1ba0684a878d9e7441f488d183b3d617373"
    sha256 cellar: :any_skip_relocation, sonoma:        "301528d8d1d071baecf6ecbcbf35e73d3c9303c794e13db3c5b347c663938b04"
    sha256 cellar: :any_skip_relocation, ventura:       "301528d8d1d071baecf6ecbcbf35e73d3c9303c794e13db3c5b347c663938b04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76df14c388beb00badb7e04b7e10e4a07ec178f51c680098085403d26ec83565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "240762bf6b644a49a813586927e720b53fddec1b3abc3781273853a52ebc7c4e"
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
