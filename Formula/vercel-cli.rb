require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.17.0.tgz"
  sha256 "f24436f950c52e69d9fc5ffe41a205dbae06fbde8e1e7058af7b94459cad8158"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3690fe79fa63800b588d66e98bd82a01bc4adb1cdf798419c135e35b3e0e2a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aa9a566d58e4d60f0d993b5fdc2708b63ccae825cff659e60a6703ea1086310"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f540a692d7eef5014b73fb16bb963a477fe0163e9eba6c0f7a62abf2d519acc"
    sha256 cellar: :any_skip_relocation, ventura:        "fb7676c09d3b159267bce92d98e74abc63b909347d2f228a62b9ea3a8d05f080"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb07423e9083476a2b73c9e3d4c9c67872a9548f8cd8eb41aa9d7b5c1f43706"
    sha256 cellar: :any_skip_relocation, big_sur:        "714ba7ab9daf5cf587da0bb1195d3494473696c8cad507fecf2991abead14dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f7e7133e0b7ee2f79d0ae0874d82d99a6517033ff146b00285d1ce2f893ff6"
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
