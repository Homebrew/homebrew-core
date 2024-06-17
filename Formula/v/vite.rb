require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.3.1.tgz"
  sha256 "ae2f3ad0bcd875e7613a0a3e818d3525da7868ed750f286b98482124d7738913"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a08fefc36d5cf224798d66e8eca6f3445b25dc2cdcc458362b4862e11a7f9c3e"
    sha256 cellar: :any,                 arm64_ventura:  "a08fefc36d5cf224798d66e8eca6f3445b25dc2cdcc458362b4862e11a7f9c3e"
    sha256 cellar: :any,                 arm64_monterey: "a08fefc36d5cf224798d66e8eca6f3445b25dc2cdcc458362b4862e11a7f9c3e"
    sha256 cellar: :any,                 sonoma:         "f82c0684764d188bd0b3e19ef99fc22d6ea9c4118b7825789037e6a843beaae6"
    sha256 cellar: :any,                 ventura:        "f82c0684764d188bd0b3e19ef99fc22d6ea9c4118b7825789037e6a843beaae6"
    sha256 cellar: :any,                 monterey:       "f82c0684764d188bd0b3e19ef99fc22d6ea9c4118b7825789037e6a843beaae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0270b2727e3c216d5eeb0adf495fa8be371c61a9332a6eb73e2a6657c689c823"
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
