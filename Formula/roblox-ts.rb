require "language/node"

class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-2.1.0.tgz"
  sha256 "cfe33e88a9973fe39543b01f945533bc392df9771915422265f9164b3d42f860"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "603722d00d6cdd36513f59dade2a1ddf66036b1409e70950e4afe1b22c0c12af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "603722d00d6cdd36513f59dade2a1ddf66036b1409e70950e4afe1b22c0c12af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "603722d00d6cdd36513f59dade2a1ddf66036b1409e70950e4afe1b22c0c12af"
    sha256 cellar: :any_skip_relocation, ventura:        "6368f79fa4e8203b148f68eae071b19de99c657349257eacae8a2d82ce22cdb6"
    sha256 cellar: :any_skip_relocation, monterey:       "6368f79fa4e8203b148f68eae071b19de99c657349257eacae8a2d82ce22cdb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6368f79fa4e8203b148f68eae071b19de99c657349257eacae8a2d82ce22cdb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6407b06d0f066e4649e0fe06d0f753650d105e147434125308078a07429048f8"
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
