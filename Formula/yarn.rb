require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://registry.npmjs.org/yarn/-/yarn-0.15.1.tgz"
  sha256 "f99fd587e84987909d5f9e918b8fe524349fdc548e5bc5c380c8f8c0a70c6b87"
  head "https://github.com/yarnpkg/yarn.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
