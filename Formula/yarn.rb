require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.19.1/yarn-v0.19.1.tar.gz"
  sha256 "751e1c0becbb2c3275f61d79ad8c4fc336e7c44c72d5296b5342a6f468526d7d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1b9445a742676dbfb6bbeac3601f14860bcd86e59b5226c5f027ca42cb308f9" => :sierra
    sha256 "4ab5849dd81ab11b4da37ea602418448d15f475eb9e54ad1fb27373a7753a253" => :el_capitan
    sha256 "bff86423ac026c491119782db5d5a73f549d27b1e376ba0afe6b31724b9c5f91" => :yosemite
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
