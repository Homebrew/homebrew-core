class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1292.4.tgz"
  sha256 "0d80f838e47573bf0e5b7b5f2038e5f9ee5ac98fe391359ea0bc4ed95ecfd95d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25108098bbf3c463f60aeca2b311b02d6d0ddb8ee4b9008a4a23bf86f638d92b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25108098bbf3c463f60aeca2b311b02d6d0ddb8ee4b9008a4a23bf86f638d92b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25108098bbf3c463f60aeca2b311b02d6d0ddb8ee4b9008a4a23bf86f638d92b"
    sha256 cellar: :any_skip_relocation, sonoma:         "885dfd0e7bb3b00b1eaddbccc0b1a45fdfe8b133d4869fc411411970cb1b83c4"
    sha256 cellar: :any_skip_relocation, ventura:        "885dfd0e7bb3b00b1eaddbccc0b1a45fdfe8b133d4869fc411411970cb1b83c4"
    sha256 cellar: :any_skip_relocation, monterey:       "885dfd0e7bb3b00b1eaddbccc0b1a45fdfe8b133d4869fc411411970cb1b83c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73660201aac6ed14f4e25ff0de9a243627924947cca2f909d70db6290a4cd000"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
