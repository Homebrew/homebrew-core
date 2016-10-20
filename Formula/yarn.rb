require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.16.1/yarn-v0.16.1.tar.gz"
  sha256 "73be27c34ef1dd4217fec23cdfb6b800cd995e9079d4c4764724ef98e98fec07"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01d2ee1cc47677f420cf0d4677ba022fa44c012260795943d663dffceb81dfd1" => :sierra
    sha256 "7cbc394d634efaecb016de9be29f800baea3541521e268e9f9cdc513978f964b" => :el_capitan
    sha256 "028842707bc0270f77a651a2fd82cd37cd1a2a30d653e487ead4c5a8edb81a76" => :yosemite
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
