class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.8.0.tgz"
  sha256 "46ddfca0922b4aaa80b6e115e2dea0d6301720bf3a76fab519f6dcd1faaaa0ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e68b1ae1c61519db09599b344d2b892211a0cd599e182a45ef38c2da6ee07c43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68b1ae1c61519db09599b344d2b892211a0cd599e182a45ef38c2da6ee07c43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e68b1ae1c61519db09599b344d2b892211a0cd599e182a45ef38c2da6ee07c43"
    sha256 cellar: :any_skip_relocation, sonoma:        "569028c6f76518602838ba0b995951d8228ba5de69fa77eb8d85e69fabef4358"
    sha256 cellar: :any_skip_relocation, ventura:       "569028c6f76518602838ba0b995951d8228ba5de69fa77eb8d85e69fabef4358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f68228238c4d9e5c1a90d99fef9316469647a30da80087846855b1544e2a3c"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
