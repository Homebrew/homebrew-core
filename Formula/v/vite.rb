class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.2.1.tgz"
  sha256 "48dd4560e0b8f6608ae7bdb19746748b82b831247d996f1c98e7b1a6e99a7e0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5c5f9a0345b715cbf2d8e7f2c2d60b140e77c7fceb80acda2be35e5c5cf30b2"
    sha256 cellar: :any,                 arm64_sonoma:  "c5c5f9a0345b715cbf2d8e7f2c2d60b140e77c7fceb80acda2be35e5c5cf30b2"
    sha256 cellar: :any,                 arm64_ventura: "c5c5f9a0345b715cbf2d8e7f2c2d60b140e77c7fceb80acda2be35e5c5cf30b2"
    sha256 cellar: :any,                 sonoma:        "d5bdaed17fcd95b19be180805b3b1df708158fd4f9b98956a7ec95d4fcc907fb"
    sha256 cellar: :any,                 ventura:       "d5bdaed17fcd95b19be180805b3b1df708158fd4f9b98956a7ec95d4fcc907fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ec93082929963efe6ab0976f1a8e47481ee99a3ca7aed961e9d696d7b87ee61"
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
