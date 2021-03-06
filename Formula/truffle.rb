require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.2.3.tgz"
  sha256 "7d18783bf55de0e044ad50c4708412f42c27196fd03d0ced14fd730fd4b6aa3a"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "e8006dd9dd1ce5c17ad796d45c8ff1498bb180be16fcc72988deaebeb523173f"
    sha256 big_sur:       "682effbb45a19c3ba3a1e8ff6f58e87afa253ae31a1a476503f3a8c810deb111"
    sha256 catalina:      "60317fe8bca44644e33fbedc93aff6fc3a7aa47ef85f09b6a4c3167c4b8b145d"
    sha256 mojave:        "64d8c8e4fa60fb426c3147df5c9cda8a9d54a69caaa5a68b13c4deacb08d5fc2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
