require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.4.tgz"
  sha256 "95ecaa1ed6df80414ce737b730f254d4fb0c90ac3dde346732ffd6569878602a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7156fd16a2569c618d3baf45988123c43b5c90e7eb1127d52ed28cfad6b6cc5b"
    sha256 cellar: :any,                 arm64_ventura:  "7156fd16a2569c618d3baf45988123c43b5c90e7eb1127d52ed28cfad6b6cc5b"
    sha256 cellar: :any,                 arm64_monterey: "7156fd16a2569c618d3baf45988123c43b5c90e7eb1127d52ed28cfad6b6cc5b"
    sha256 cellar: :any,                 sonoma:         "626ed3e72f4f93a51b7f27bae1c1d11f4370b5528b0c4c4f2a26f8776d5bc758"
    sha256 cellar: :any,                 ventura:        "626ed3e72f4f93a51b7f27bae1c1d11f4370b5528b0c4c4f2a26f8776d5bc758"
    sha256 cellar: :any,                 monterey:       "626ed3e72f4f93a51b7f27bae1c1d11f4370b5528b0c4c4f2a26f8776d5bc758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3e188fffd92817c5e3419014816cb023079b68b38243778beea3568b88ea240"
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
