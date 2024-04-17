require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.9.tgz"
  sha256 "efa418ab1ccca4b0a7ab9c72af98c24b9a2ecec3cb2e84f14b40841630a8227c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c379756f19c6e0af3b764485706e1de66d39c5cb0298d376e297b5754959a562"
    sha256 cellar: :any,                 arm64_ventura:  "c379756f19c6e0af3b764485706e1de66d39c5cb0298d376e297b5754959a562"
    sha256 cellar: :any,                 arm64_monterey: "c379756f19c6e0af3b764485706e1de66d39c5cb0298d376e297b5754959a562"
    sha256 cellar: :any,                 sonoma:         "9af789fd14afc7aafe2c3bce7ce5954173f70e48074abc8302b379e6b1001972"
    sha256 cellar: :any,                 ventura:        "9af789fd14afc7aafe2c3bce7ce5954173f70e48074abc8302b379e6b1001972"
    sha256 cellar: :any,                 monterey:       "9af789fd14afc7aafe2c3bce7ce5954173f70e48074abc8302b379e6b1001972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6770ff50ad6b2fd3c17e021c4a6843c0c0883966afd7580540d85a0f6875c3d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
