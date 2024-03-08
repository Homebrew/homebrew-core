require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.5.5.tgz"
  sha256 "2f43985fee72037b876ffa3110a29cce6d37b86751e004c12ea93217613abb8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7eb4c2b251e15e4855579b476a85e6b9d078fdd9f25314c893fa48de8d216c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7eb4c2b251e15e4855579b476a85e6b9d078fdd9f25314c893fa48de8d216c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7eb4c2b251e15e4855579b476a85e6b9d078fdd9f25314c893fa48de8d216c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "68794de52a90e6967f19c9d2d3a88baea230931eb1ab88ace6856280799454e2"
    sha256 cellar: :any_skip_relocation, ventura:        "68794de52a90e6967f19c9d2d3a88baea230931eb1ab88ace6856280799454e2"
    sha256 cellar: :any_skip_relocation, monterey:       "68794de52a90e6967f19c9d2d3a88baea230931eb1ab88ace6856280799454e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7a0ba01eff6313900e7f5a57237a8f166e1a715f6791d343b168563049228cd"
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
