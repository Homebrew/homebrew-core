require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.0.0.tgz"
  sha256 "08ee9e0941bbd8e29c711ecdd73ab1a8cacbe300e14c2f36e94227d37cd17081"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "498e2feb8bc547a29707daa2d4a6cd9fda7e8cbe821ae0e556109b6674257ab9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "498e2feb8bc547a29707daa2d4a6cd9fda7e8cbe821ae0e556109b6674257ab9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "498e2feb8bc547a29707daa2d4a6cd9fda7e8cbe821ae0e556109b6674257ab9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb9836095831794b4452a089b9eb86b9f7e67f6c37b796f28abc5fd8669d4916"
    sha256 cellar: :any_skip_relocation, ventura:        "fb9836095831794b4452a089b9eb86b9f7e67f6c37b796f28abc5fd8669d4916"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9836095831794b4452a089b9eb86b9f7e67f6c37b796f28abc5fd8669d4916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a33435b36ba1290f435ffec68f69e97c99313b8a48379f8ea2ae3da2e8213d7"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
