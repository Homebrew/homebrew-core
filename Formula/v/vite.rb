require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.2.tgz"
  sha256 "88ea6d80139b60e1247681cdcace13d16603c5512cead9ce47cd8784581d2eb3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "daa9e4e2e8ea2a588b2ca8639cdb57c32bd84b5b793609e695a1b4bc7757a40c"
    sha256 cellar: :any,                 arm64_ventura:  "daa9e4e2e8ea2a588b2ca8639cdb57c32bd84b5b793609e695a1b4bc7757a40c"
    sha256 cellar: :any,                 arm64_monterey: "daa9e4e2e8ea2a588b2ca8639cdb57c32bd84b5b793609e695a1b4bc7757a40c"
    sha256 cellar: :any,                 sonoma:         "eccfb70e9eae4f46dc1540d137de310594a6e08bcc80345fc6ec80e136a64df8"
    sha256 cellar: :any,                 ventura:        "eccfb70e9eae4f46dc1540d137de310594a6e08bcc80345fc6ec80e136a64df8"
    sha256 cellar: :any,                 monterey:       "eccfb70e9eae4f46dc1540d137de310594a6e08bcc80345fc6ec80e136a64df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "701c46ec9a23fda3bae5be8f4ee99c7c88a6ad71f8a4ca17e6b258d0421104e0"
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
