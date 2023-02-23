require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.5.tgz"
  sha256 "91d62a61417a934293d6ef1c06a7f1059cf84e2e9acf4d39bd692f313fc253d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b3ee13ae885de147bfe3652d43f19924343260eeba8569f4f059557bbc1c43f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26398b6118adc1bcaefed674a9efdb91c0e70d4a5cec5daef13ec2527281a4f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be8f28acb1ad0b81aa361e3a10983ae000b0c3fe9d424603e2f867976baffe41"
    sha256 cellar: :any_skip_relocation, ventura:        "325f0ff540eeef025445c66734fb2990b5f5bd08078b2cbb253be04adf3822be"
    sha256 cellar: :any_skip_relocation, monterey:       "c9b5e7d504f20b308d0da7dc2e361c7386bb59c8d1d403b13a642cf0891ff9d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad89edf20e544929e1b8d34fea211694d565b1bd23e150acf06dba980ecd1bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ca71166c031ae14b76b0b4ccfa73ba5e2b124c8f1e37a3ccee204485bf60c7"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
