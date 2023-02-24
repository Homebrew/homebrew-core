require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.6.tgz"
  sha256 "dd8e6749f626cd79948c0d121a94c01dd10a7ff21d2b5f42e3d884c1ed7d08f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293144bc4ec87c0f3063ecef37324f61afea84c31f5c21b70eab4a5dec1a62a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b888c9e5efd98990fb3c8b1b687fe6000087be9fb4d4258b74193cd67e2db9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ef2a3ec3e20b69bd378804c8a82e6f8008a96461dab0ddd5023b08c7f20afe4"
    sha256 cellar: :any_skip_relocation, ventura:        "77e4951d2be84df16d6bb3616239f769456fb8941023affdb7c2cba6e3e21558"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea7384e386c138727d677118944328688e97938c82fe2b83dd137d2089e9e11"
    sha256 cellar: :any_skip_relocation, big_sur:        "13e4447210464abc33e82151b805cf2f2322d913416ca565f2ed40a6f6f57689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f987cd80f6ed407436632e43c7d0d7c7de339c4076fe01a1ab4b18e825620ec"
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
