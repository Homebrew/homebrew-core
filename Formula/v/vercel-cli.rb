class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.3.0.tgz"
  sha256 "fac1eed2a1224acb125c15c8668d79de1c6c17321b6cb0067618e32c6750646f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf795afd988bfd2158f806a3e39e8a18a54d5973896ac7e431832a5f64d4c0b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf795afd988bfd2158f806a3e39e8a18a54d5973896ac7e431832a5f64d4c0b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf795afd988bfd2158f806a3e39e8a18a54d5973896ac7e431832a5f64d4c0b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "608dc76481874b7e4e16f9f1a012b2b5a47534123915dfb44fc98e8c171b3d40"
    sha256 cellar: :any_skip_relocation, ventura:       "608dc76481874b7e4e16f9f1a012b2b5a47534123915dfb44fc98e8c171b3d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8de68a4584469cf499b51694b6d99c2104693f1b5f15dc7bdecb754f6cd86102"
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
