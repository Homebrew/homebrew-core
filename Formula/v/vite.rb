require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.0.tgz"
  sha256 "24ba17dfeaec6b2b91afd47f94deceeef7caae1db17db043d0cd430e97a98017"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "795046207a17a022cd7dc4d1f33c9743f2268f2b72d1193ae5e1fabc2ffd74ee"
    sha256 cellar: :any,                 arm64_ventura:  "795046207a17a022cd7dc4d1f33c9743f2268f2b72d1193ae5e1fabc2ffd74ee"
    sha256 cellar: :any,                 arm64_monterey: "795046207a17a022cd7dc4d1f33c9743f2268f2b72d1193ae5e1fabc2ffd74ee"
    sha256 cellar: :any,                 sonoma:         "9398962e22c03a4c292e335fd5e85a5fb414525c98d7b0ff8a129e4151ccf7cd"
    sha256 cellar: :any,                 ventura:        "9398962e22c03a4c292e335fd5e85a5fb414525c98d7b0ff8a129e4151ccf7cd"
    sha256 cellar: :any,                 monterey:       "9398962e22c03a4c292e335fd5e85a5fb414525c98d7b0ff8a129e4151ccf7cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "770c2f68d5f68dac0ec7bd3445de5603f18983ca4046ecd07486c0cb2d8bc875"
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
