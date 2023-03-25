require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.18.1.tgz"
  sha256 "6e5b46dbdda60807deea8df0416bb72f4ed62fc23f0dab18674fe7434ee2e9e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "443c9f286e39bd60415ac683046a0b3fd568e626af6f2a19d723763451d6cb8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "672e9b5f2a03a160a79a0676574a098bfd7fe840aa6190f2539f9634ff747198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "737a34762a5063c8822165809e7bb429c6ec71c9da8edb4eda65b3bf22e98699"
    sha256 cellar: :any_skip_relocation, ventura:        "0760974f9972c3d1973c84f5ed4b06cb769383a56939a5b8a90e687cee22e96d"
    sha256 cellar: :any_skip_relocation, monterey:       "4bebd79d77e48efcc18d5264a0d48202c1d26662d8621f65c3b71b6184d996b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "710a1873b05cb5da9c6ba40f48552dc4925f189c30a5bdbbb28031c24257a344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b269e2194a0778287189886f18e53ff57aee4d689789de6f26a8a50391be9f67"
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
