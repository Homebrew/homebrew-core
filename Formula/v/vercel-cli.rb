class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-36.0.0.tgz"
  sha256 "de50d934b10fe041f3ac19afaf4d258dc210585cb67a6b7d7bc33fb265176771"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76b88b6dc18545d60beb9fc3220f88c3faaa9ac736696a152f9cc3dd76b6d239"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76b88b6dc18545d60beb9fc3220f88c3faaa9ac736696a152f9cc3dd76b6d239"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76b88b6dc18545d60beb9fc3220f88c3faaa9ac736696a152f9cc3dd76b6d239"
    sha256 cellar: :any_skip_relocation, sonoma:         "81af591f16c26cac2ced328f80a426161f619270a9c40720550d82fe762fef16"
    sha256 cellar: :any_skip_relocation, ventura:        "81af591f16c26cac2ced328f80a426161f619270a9c40720550d82fe762fef16"
    sha256 cellar: :any_skip_relocation, monterey:       "81af591f16c26cac2ced328f80a426161f619270a9c40720550d82fe762fef16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91cda1f3f38af50ae6d3be2e9689f34facb926f625b5bef608ab1a484e7ffd42"
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
