require "language/node"

class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.0.1.tgz"
  sha256 "d86226455af51fd31d1e82bc8b7ff2ca6ca7d15cd3d0351a5c09473f9ba7d3ee"
  license "Apache-2.0"
  head "https://github.com/RetireJS/retire.js.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34f925e170fc98e2747c9c041c4d6046337ada00b677cea59cf36fa9c8d79cd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f925e170fc98e2747c9c041c4d6046337ada00b677cea59cf36fa9c8d79cd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34f925e170fc98e2747c9c041c4d6046337ada00b677cea59cf36fa9c8d79cd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "34f925e170fc98e2747c9c041c4d6046337ada00b677cea59cf36fa9c8d79cd2"
    sha256 cellar: :any_skip_relocation, ventura:        "34f925e170fc98e2747c9c041c4d6046337ada00b677cea59cf36fa9c8d79cd2"
    sha256 cellar: :any_skip_relocation, monterey:       "34f925e170fc98e2747c9c041c4d6046337ada00b677cea59cf36fa9c8d79cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eb9df55ab18cf43dd141a6e7a0e14dbb03156e2b79a5a81c2a9f9f35af53807"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
