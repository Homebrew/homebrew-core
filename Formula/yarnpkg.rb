require "language/node"

class Yarnpkg < Formula
  desc "Yarn javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://registry.npmjs.org/yarnpkg/-/yarnpkg-0.15.1.tgz"
  sha256 "fc93a937956678ba1657adb9cd65208223cd49eff3e2060e670cfc29c0337002"
  head "https://github.com/yarnpkg/yarn.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"yarn", "--help"
  end
end
