class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-43.1.0.tgz"
  sha256 "9de563241eb30d5e3b3c7904c3898a533481e208522385a18f4878b2c9a14754"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a21655cf1c35ae5d52348b276a6d9d5c7e7755aa6884785b982174980e14747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a21655cf1c35ae5d52348b276a6d9d5c7e7755aa6884785b982174980e14747"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a21655cf1c35ae5d52348b276a6d9d5c7e7755aa6884785b982174980e14747"
    sha256 cellar: :any_skip_relocation, sonoma:        "46543cc843ced33752966aa7c390e95eea94c7f97ca692a945a4d2070448dd8c"
    sha256 cellar: :any_skip_relocation, ventura:       "46543cc843ced33752966aa7c390e95eea94c7f97ca692a945a4d2070448dd8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fdbf2e756eaf887db5149ca8406dfc7b7afa576f33f69e9070074d64b69fa9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf704b94945eeb9c057510cdcf16fc1dae453677e6567d764510456d30eb564"
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
