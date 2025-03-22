class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.4.1.tgz"
  sha256 "800ce0ff1ebe96175065d0befc45619efbfe2a492f6bda1f517b2db779bde08e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f2013f4dfd80caa6d0e5aea74ed4ba2bd672eab8274ff09cdb9d577e4a0aed1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f2013f4dfd80caa6d0e5aea74ed4ba2bd672eab8274ff09cdb9d577e4a0aed1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f2013f4dfd80caa6d0e5aea74ed4ba2bd672eab8274ff09cdb9d577e4a0aed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "42d46561ab7d2e7f7a6fead6824ef91e260830e6de6d058455ed00f8423739ed"
    sha256 cellar: :any_skip_relocation, ventura:       "42d46561ab7d2e7f7a6fead6824ef91e260830e6de6d058455ed00f8423739ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35e5fce301ffa2c8355337c04a45ebbd02d72bcb9fe3b9ab4f917ad6ba26f7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a58208e39e7e59a9137cd840baa5b154ddbcaa30ae467a84854545cc8cca2d0"
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
