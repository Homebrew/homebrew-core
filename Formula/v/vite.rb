require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.5.tgz"
  sha256 "5de1878532962c73872b0db9d47ef05af8012d1ecd7c3c686d059c44f284af67"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bf0ac0cb6122005e515305c17cf26cdb8fcaa927ebff87ba8de8d8d852ba6737"
    sha256 cellar: :any,                 arm64_ventura:  "bf0ac0cb6122005e515305c17cf26cdb8fcaa927ebff87ba8de8d8d852ba6737"
    sha256 cellar: :any,                 arm64_monterey: "bf0ac0cb6122005e515305c17cf26cdb8fcaa927ebff87ba8de8d8d852ba6737"
    sha256 cellar: :any,                 sonoma:         "45fc537246c9ddc1dcb6a2696d02c75070d0205fd90f83e297def9875aac947f"
    sha256 cellar: :any,                 ventura:        "45fc537246c9ddc1dcb6a2696d02c75070d0205fd90f83e297def9875aac947f"
    sha256 cellar: :any,                 monterey:       "45fc537246c9ddc1dcb6a2696d02c75070d0205fd90f83e297def9875aac947f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155dc55befb95e21c6b01f995ee3a6cac14d2b52d425955eef3f093b289b6b20"
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
