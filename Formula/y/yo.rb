class Yo < Formula
  desc "CLI tool for running Yeoman generators"
  homepage "https://yeoman.io"
  url "https://registry.npmjs.org/yo/-/yo-5.1.0.tgz"
  sha256 "b3b2abe646c47d8e60b93394ed219779dce26347c59d8ba337a62ea4226e1ec5"
  license "BSD-2-Clause"
  head "https://github.com/yeoman/yo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "77fd73f75ed33e9578034e848c34266cabcc4db3fee4146d0901ab8977b64a2b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
    assert_match "Everything looks all right!", shell_output("#{bin}/yo doctor")
  end
end
