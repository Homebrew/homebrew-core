require "language/node"

class TapeCli < Formula
  desc "CLI for mobile devs - share screenshots, recordings as video or GIFs"
  homepage "https://tape.sh/"
  url "https://registry.npmjs.org/tape-cli/-/tape-cli-0.11.1.tgz"
  sha256 "9e9464e72c239e99f7d392f8b45f40ece40bd54ba43683c646907d81b9a51a18"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    ohai "🎉 Please run `tape config --setup` to get started \n"
  end

  test do
    output = shell_output("#{bin}/tape config --check")
    assert_match "Run tape config", output.squeeze # large output
  end
end
