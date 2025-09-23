class WebosCli < Formula
  desc "Command-Line Interface (CLI) for webOS"
  homepage "https://webostv.developer.lge.com/develop/tools/cli-introduction"
  url "https://registry.npmjs.org/@webos-tools/cli/-/cli-3.2.1.tgz"
  sha256 "a9c92a8500ab523cf9b5d57f91f7c3bca9947ca87c2de4230f9e5caada002094"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    version_out = shell_output("#{bin}/ares -V")
    assert_match version.to_s, version_out

    generate_out = shell_output("#{bin}/ares-generate -t basic -p \"{'id':'sh.brew.test'}\" #{testpath}/test_app")
    assert_match "Success", generate_out
  end
end
