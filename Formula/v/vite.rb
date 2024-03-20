require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.0.tgz"
  sha256 "24ba17dfeaec6b2b91afd47f94deceeef7caae1db17db043d0cd430e97a98017"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71686255e793b4d64ddf11a66d77f0b2ad181fdf90aa66bc22f779cbada80d0b"
    sha256 cellar: :any,                 arm64_ventura:  "71686255e793b4d64ddf11a66d77f0b2ad181fdf90aa66bc22f779cbada80d0b"
    sha256 cellar: :any,                 arm64_monterey: "71686255e793b4d64ddf11a66d77f0b2ad181fdf90aa66bc22f779cbada80d0b"
    sha256 cellar: :any,                 sonoma:         "05f0048d35523680654d426ee9c406df3054e18df7f0604215fe5e381b6c1d78"
    sha256 cellar: :any,                 ventura:        "05f0048d35523680654d426ee9c406df3054e18df7f0604215fe5e381b6c1d78"
    sha256 cellar: :any,                 monterey:       "05f0048d35523680654d426ee9c406df3054e18df7f0604215fe5e381b6c1d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1b65cce4409dd4d9074f0919d35a69c7336992184327430d8efd92d40eb02c"
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
