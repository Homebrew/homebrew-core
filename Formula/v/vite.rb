class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.9.tgz"
  sha256 "45898720cbe624d415ab5a55e242ea37ad447d0562d173ef66e49fac0887fccb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "305675ca06c17bb99275872f80bd79e33b53602c4c37dcee2139faf6395d3048"
    sha256 cellar: :any,                 arm64_sonoma:  "305675ca06c17bb99275872f80bd79e33b53602c4c37dcee2139faf6395d3048"
    sha256 cellar: :any,                 arm64_ventura: "305675ca06c17bb99275872f80bd79e33b53602c4c37dcee2139faf6395d3048"
    sha256 cellar: :any,                 sonoma:        "2d71fbcbce50bdb337368547734f5c3c96a9959496013065b25ec36045e71267"
    sha256 cellar: :any,                 ventura:       "2d71fbcbce50bdb337368547734f5c3c96a9959496013065b25ec36045e71267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c1500e1a0b035c8ab976957d312af9d1cfc6597fd5826eec68ede7ea9284ec"
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
