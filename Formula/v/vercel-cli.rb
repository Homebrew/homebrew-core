class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.11.0.tgz"
  sha256 "c06cc8a3b166fa3449d0e01c82c85a89259e7a7cfe0c62ad9078a3e8458ee5d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73ed61e9d0052ef16c8468202af555b11650a3e70487a36751be61589fbfa1a5"
    sha256 cellar: :any,                 arm64_sequoia: "47c186bf4824e4c77a063a0459d3fcfeee65f0b40c18fc5c8d43cabb2833a5a3"
    sha256 cellar: :any,                 arm64_sonoma:  "47c186bf4824e4c77a063a0459d3fcfeee65f0b40c18fc5c8d43cabb2833a5a3"
    sha256 cellar: :any,                 sonoma:        "115af58b9c08eec8b38bb9e6e2943169e6f48e0a9c6d0d3156ee84a23e71f661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d2fe2031c03db9bba367ff6a7c23d2160b031f5b54d793ddda25d95f49387c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac8957db6e830480f9791f474926740f09c5ac8c2e6bab14589ef2e882b7fffa"
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
