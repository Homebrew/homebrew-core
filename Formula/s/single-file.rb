require "language/node"

class SingleFile < Formula
  desc "CLI tool for saving a faithful copy of a complete web page in a single HTML file"
  homepage "https://github.com/gildas-lormeau/single-file-cli/"
  url "https://registry.npmjs.org/single-file-cli/-/single-file-cli-2.0.34.tgz"
  sha256 "347d834bf0c80306981094c6c62ddf5a5bd55132d452d402b8afc4ddc1af878d"
  license "AGPL-3.0-or-later"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Invalid URL or file path: undefined",
shell_output("#{bin}/single-file --error-file")
  end
end
