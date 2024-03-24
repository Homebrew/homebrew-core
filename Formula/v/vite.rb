require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.5.tgz"
  sha256 "5de1878532962c73872b0db9d47ef05af8012d1ecd7c3c686d059c44f284af67"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cc3efc67c327b26a5f713be53be88e6dac85439520ad155682caa506336951b8"
    sha256 cellar: :any,                 arm64_ventura:  "cc3efc67c327b26a5f713be53be88e6dac85439520ad155682caa506336951b8"
    sha256 cellar: :any,                 arm64_monterey: "cc3efc67c327b26a5f713be53be88e6dac85439520ad155682caa506336951b8"
    sha256 cellar: :any,                 sonoma:         "8ae67649901dd1f0164df796f6e601e225642495241963bc3de8bca5142e893f"
    sha256 cellar: :any,                 ventura:        "8ae67649901dd1f0164df796f6e601e225642495241963bc3de8bca5142e893f"
    sha256 cellar: :any,                 monterey:       "8ae67649901dd1f0164df796f6e601e225642495241963bc3de8bca5142e893f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76a267c46f0b241b659f3230e27ab9c364171c5acd9328dd6ef10d7b2b4f996e"
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
