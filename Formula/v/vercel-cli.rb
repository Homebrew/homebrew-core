class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.6.2.tgz"
  sha256 "d89f092596941a65b7f16006c201f7b2fc1a94cfc401ccd2c9cbf7f0202f5bd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff406234f6790856a4b517807fa42786fdc20db0ef1ec63498d1abcdc47991b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff406234f6790856a4b517807fa42786fdc20db0ef1ec63498d1abcdc47991b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff406234f6790856a4b517807fa42786fdc20db0ef1ec63498d1abcdc47991b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e6ee81e4b76ff833cc47f06907477a0d339c50ca639c1b694b8a799768c2f1"
    sha256 cellar: :any_skip_relocation, ventura:       "f8e6ee81e4b76ff833cc47f06907477a0d339c50ca639c1b694b8a799768c2f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d60c6d3d681818292dbbd2eb3aa3e4738d5e87a22d0232c89f203180d7e0caa"
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
