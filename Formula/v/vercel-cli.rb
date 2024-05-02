require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.7.tgz"
  sha256 "eaddb23abc4364efc96c451cd5190de86125777b2cd26c3bb25ac974f92eb73f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cbe78f99e248b2f60077e6f7b6d9db032342d104812db3a6f9bdeafedb82262"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cbe78f99e248b2f60077e6f7b6d9db032342d104812db3a6f9bdeafedb82262"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cbe78f99e248b2f60077e6f7b6d9db032342d104812db3a6f9bdeafedb82262"
    sha256 cellar: :any_skip_relocation, sonoma:         "a67125a2e0a2cd63ad4b6596fd874a161e73b9d4d9ccfeff9d5c605216c1ef80"
    sha256 cellar: :any_skip_relocation, ventura:        "a67125a2e0a2cd63ad4b6596fd874a161e73b9d4d9ccfeff9d5c605216c1ef80"
    sha256 cellar: :any_skip_relocation, monterey:       "a67125a2e0a2cd63ad4b6596fd874a161e73b9d4d9ccfeff9d5c605216c1ef80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c31dd57a1592ea1d369febc3a0d6d0860d8d0c4c8d7701f793f8f3be2e201158"
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
