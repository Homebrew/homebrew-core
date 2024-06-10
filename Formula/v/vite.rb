require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.13.tgz"
  sha256 "314792d2c86a216451f8abc4a992f8e9c0b1f1963ce77a6ec8b93d628bc25508"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ea1a64774ab0115380dbc5ada046cea50da1366b5d0e06ea192124e9d3be00c"
    sha256 cellar: :any,                 arm64_ventura:  "8ea1a64774ab0115380dbc5ada046cea50da1366b5d0e06ea192124e9d3be00c"
    sha256 cellar: :any,                 arm64_monterey: "8ea1a64774ab0115380dbc5ada046cea50da1366b5d0e06ea192124e9d3be00c"
    sha256 cellar: :any,                 sonoma:         "25b9eaa05d495e02d60f53e240bd8ae8227b6d6fb9f70022360ac8b3748c5b73"
    sha256 cellar: :any,                 ventura:        "25b9eaa05d495e02d60f53e240bd8ae8227b6d6fb9f70022360ac8b3748c5b73"
    sha256 cellar: :any,                 monterey:       "25b9eaa05d495e02d60f53e240bd8ae8227b6d6fb9f70022360ac8b3748c5b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d850b73c9d68f8332ed2b040c394ff9a811245553f02d70a9e5ec1c29f2c3b5d"
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
