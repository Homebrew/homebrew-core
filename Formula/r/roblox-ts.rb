require "language/node"

class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-2.2.0.tgz"
  sha256 "3fa23b1d2f7b3daf6be39f03e6c72b7a29f56f3995348d38bc931530becdca53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf9da20fd24dd9cb54822277533b44f2ec347bf437958a133eda571d0c0aeb93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf9da20fd24dd9cb54822277533b44f2ec347bf437958a133eda571d0c0aeb93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf9da20fd24dd9cb54822277533b44f2ec347bf437958a133eda571d0c0aeb93"
    sha256 cellar: :any_skip_relocation, sonoma:         "dae9e3fb7e6887c5fdcf4d7d4fbb46aa84cb340a7c89a94bd8a25ff656d4e218"
    sha256 cellar: :any_skip_relocation, ventura:        "dae9e3fb7e6887c5fdcf4d7d4fbb46aa84cb340a7c89a94bd8a25ff656d4e218"
    sha256 cellar: :any_skip_relocation, monterey:       "dae9e3fb7e6887c5fdcf4d7d4fbb46aa84cb340a7c89a94bd8a25ff656d4e218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "911a62c95e6df1e05f82cfd2de03e6fe8bca2c808bf54d2a3444e01af47ad680"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    system bin/"rbxtsc", "init", "game", "-y"
    assert_predicate testpath/"package.json", :exist?
    assert_predicate testpath/"package-lock.json", :exist?
  end
end
