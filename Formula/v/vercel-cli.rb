class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.1.1.tgz"
  sha256 "97f633f9ed707bb525ed75cf108b80e71607829d277591c0e588db801180598d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "303f431b91762755a8ccf7299cace66f7a031ceb618d3880bec9ed316c1c00d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303f431b91762755a8ccf7299cace66f7a031ceb618d3880bec9ed316c1c00d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "303f431b91762755a8ccf7299cace66f7a031ceb618d3880bec9ed316c1c00d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3641d1dde1877ca6b4f76368a148dec3a319afeb9bc619361af708f7532ee504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9122acb29035d6985d0db135d5309265d34fcb78c8e2dd3f6db5241661902bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd7ed94d646717804edb4ad0093245997669e389dd36afc588e7bd831491296a"
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
