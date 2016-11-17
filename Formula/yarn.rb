require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.3/yarn-v0.17.3.tar.gz"
  sha256 "883df435f68ce47c93c2e4be27acbd4122ae52ef4d334f75104c0c5e187a9173"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3cdef013027989dbef439b55df86d94f5ecc3defa83fbd8434edeb7849d6c79" => :sierra
    sha256 "0d5ef00d46efc9620b6296a4898e9b64bafdc0e140c57ed1db858d8d9b40c954" => :el_capitan
    sha256 "7561a3d2f5279c3c9af65f8d16288286bf4ecfcc3899e660628bb2d6844cd1e3" => :yosemite
  end

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
