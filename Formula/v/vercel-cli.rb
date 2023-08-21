require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.4.0.tgz"
  sha256 "3d0e9f2d1c7179dcdb377569f87c7623a9ba23951062b0dc61cbea13c6aa8ab3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "773e3d946bde43791f11f9d9f6d052f7a7505bcdaa25ebf0ab979b1ddc92e826"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "773e3d946bde43791f11f9d9f6d052f7a7505bcdaa25ebf0ab979b1ddc92e826"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "773e3d946bde43791f11f9d9f6d052f7a7505bcdaa25ebf0ab979b1ddc92e826"
    sha256 cellar: :any_skip_relocation, ventura:        "27264715189e763ac66457d5cd43048fe93df52c68ef22495e5a0b25b843c931"
    sha256 cellar: :any_skip_relocation, monterey:       "27264715189e763ac66457d5cd43048fe93df52c68ef22495e5a0b25b843c931"
    sha256 cellar: :any_skip_relocation, big_sur:        "27264715189e763ac66457d5cd43048fe93df52c68ef22495e5a0b25b843c931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf858504bbc8f0a264134667b9db2f5fba8b8e8ef8b97a4408f291831e6e987d"
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
