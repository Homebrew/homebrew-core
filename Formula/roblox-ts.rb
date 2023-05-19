require "language/node"

class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-2.1.0.tgz"
  sha256 "cfe33e88a9973fe39543b01f945533bc392df9771915422265f9164b3d42f860"
  license "MIT"

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
