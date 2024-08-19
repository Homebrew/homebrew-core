class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.1.tgz"
  sha256 "63506c3bb0538dc02e1bdbeb98e4269c18a45bcef0fc37c57c57e88c8dfa7bc0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d431774a49dbbc07d0504c8748786667ba14c7a278161ede9e1b531176f63d3"
    sha256 cellar: :any,                 arm64_ventura:  "2d431774a49dbbc07d0504c8748786667ba14c7a278161ede9e1b531176f63d3"
    sha256 cellar: :any,                 arm64_monterey: "2d431774a49dbbc07d0504c8748786667ba14c7a278161ede9e1b531176f63d3"
    sha256 cellar: :any,                 sonoma:         "dce24458828f9120626b6c48066d36041a5c8fee3df148326754e9652fac0079"
    sha256 cellar: :any,                 ventura:        "dce24458828f9120626b6c48066d36041a5c8fee3df148326754e9652fac0079"
    sha256 cellar: :any,                 monterey:       "dce24458828f9120626b6c48066d36041a5c8fee3df148326754e9652fac0079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b25edfa9bd7d4ce186730d9dcf825323a80cd0a24bfa451495d976e40403504"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
