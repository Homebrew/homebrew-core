require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.11.tgz"
  sha256 "69f3a90e05c69ea5091ba1ecfe3df257f68a5ffe9944591d80044bc53b9120b2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2f2f0cb6aace084feb162b0232bf59461afe399926f2fe12f81c657baf78915"
    sha256 cellar: :any,                 arm64_ventura:  "c2f2f0cb6aace084feb162b0232bf59461afe399926f2fe12f81c657baf78915"
    sha256 cellar: :any,                 arm64_monterey: "c2f2f0cb6aace084feb162b0232bf59461afe399926f2fe12f81c657baf78915"
    sha256 cellar: :any,                 sonoma:         "af0ccf748ee03dde5e00f7d81e1ff324e6a4ddc5f8fe4673ccfaf5b65f05c52c"
    sha256 cellar: :any,                 ventura:        "af0ccf748ee03dde5e00f7d81e1ff324e6a4ddc5f8fe4673ccfaf5b65f05c52c"
    sha256 cellar: :any,                 monterey:       "af0ccf748ee03dde5e00f7d81e1ff324e6a4ddc5f8fe4673ccfaf5b65f05c52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d1fef666a3c8fc5597635270d695480f8f8018d8ff6e0a54445a7c59f5e1f5a"
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
