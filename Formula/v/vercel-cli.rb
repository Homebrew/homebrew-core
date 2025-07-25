class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.6.1.tgz"
  sha256 "998ffdb0721e7ff00045662b396a0c4172155a69251a7dc3e03cb243a1086517"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c7e2ca7f3fa7a0e22438d553fcd2eb235079ebd0971830f81108af7a68da911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7e2ca7f3fa7a0e22438d553fcd2eb235079ebd0971830f81108af7a68da911"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c7e2ca7f3fa7a0e22438d553fcd2eb235079ebd0971830f81108af7a68da911"
    sha256 cellar: :any_skip_relocation, sonoma:        "e598cb28dad99b29e259a4ed5e62d13f762d88fd50aa5732f89dfb2e5fe46a77"
    sha256 cellar: :any_skip_relocation, ventura:       "e598cb28dad99b29e259a4ed5e62d13f762d88fd50aa5732f89dfb2e5fe46a77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d26ca306785b7c92d979af6e902c7c85b8a68b5fc048b9f1ff06f21feac9b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4003996fca9eb855cb007ac6b1321c56f68ae68fc6feebf9055709a5e88dfb87"
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
