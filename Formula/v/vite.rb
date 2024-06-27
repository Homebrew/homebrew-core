require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.3.2.tgz"
  sha256 "46ca03b5ae194a01e2f5352e6d602649c3f3cd3021829d27fb14ad1ac9e538ef"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a412e32d6fce344f574a6ed46dc2e7dcab7edfe969f8306f6e586e7d06784b5"
    sha256 cellar: :any,                 arm64_ventura:  "7a412e32d6fce344f574a6ed46dc2e7dcab7edfe969f8306f6e586e7d06784b5"
    sha256 cellar: :any,                 arm64_monterey: "7a412e32d6fce344f574a6ed46dc2e7dcab7edfe969f8306f6e586e7d06784b5"
    sha256 cellar: :any,                 sonoma:         "28dc53a17cf68e9271b4257ea14b7c33f5cd63955995b2ab15c3996c71466348"
    sha256 cellar: :any,                 ventura:        "28dc53a17cf68e9271b4257ea14b7c33f5cd63955995b2ab15c3996c71466348"
    sha256 cellar: :any,                 monterey:       "28dc53a17cf68e9271b4257ea14b7c33f5cd63955995b2ab15c3996c71466348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c20d4052d745b09ee1cf6bfde7aea1a9317d004860b104c3c6c25db16c462386"
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
