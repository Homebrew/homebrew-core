require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1284.0.tgz"
  sha256 "2b792172cc61315076206962405a51e15b9b982863d88f91a67a9f0779c4b604"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69f309619da8aea42bb5872ce55ac2d10d3c81de9aaa077bd5ed104900f26789"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cdaeb78404c47cc7e59828cfea53cde13244e26524d83421a01b860956411e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea71ab0068688387e8e769bc431f3356c263e35437f36d2bf5de0679c24b4bc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3449c5d8f769ca32037b344f7ef99acbcaf548c3dba25e96a62ab860c9e212c"
    sha256 cellar: :any_skip_relocation, ventura:        "642bffdbad79d1d15a5806182e01117280f5610048796b3b57ae2d4ca015df4c"
    sha256 cellar: :any_skip_relocation, monterey:       "c25335b1ac1301b8e7f44adfb65920b80d7a47a31953afa7479fdc3a1442dee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51760c81c3b2cd900ffe1608d9ee5198a7a9c6ba70e0b13b56f6b4cb67ed4081"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
