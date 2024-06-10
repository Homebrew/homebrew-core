require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.6.tgz"
  sha256 "c64599d03df253ff09b0380070f209032422aacf51a8f3eab80e06425fc25892"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ad186837f6b9d0b7636a783768249198f57f782e82bda7fff81ec393472e8d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ad186837f6b9d0b7636a783768249198f57f782e82bda7fff81ec393472e8d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ad186837f6b9d0b7636a783768249198f57f782e82bda7fff81ec393472e8d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "02d00b6898761e00b6aa6f7295fbde74141cc1b9474135b7c4f24a22b1aa8efc"
    sha256 cellar: :any_skip_relocation, ventura:        "02d00b6898761e00b6aa6f7295fbde74141cc1b9474135b7c4f24a22b1aa8efc"
    sha256 cellar: :any_skip_relocation, monterey:       "02d00b6898761e00b6aa6f7295fbde74141cc1b9474135b7c4f24a22b1aa8efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb05ef0940363f3d0ede0894819aa4276475b92f31024e003605497a6640488b"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
