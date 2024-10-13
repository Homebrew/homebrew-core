class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.58.tgz"
  sha256 "4c9c7989f02506e241d0921921859b7b0774b6fed9ed3fe90983f9f877248e76"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "45d2d5cabe04b4732bd621e5122be6c13c21801bcc9f640f3c5fd75566b1b5db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7af7bf5604302bd96ca405f8a0c87899dcfb28b5a2ec42683056bd927e35e014"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af7bf5604302bd96ca405f8a0c87899dcfb28b5a2ec42683056bd927e35e014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af7bf5604302bd96ca405f8a0c87899dcfb28b5a2ec42683056bd927e35e014"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1bd4461658238c02a202e46eced58172c0bf36840fade819102da0f246dcdf2"
    sha256 cellar: :any_skip_relocation, ventura:        "e1bd4461658238c02a202e46eced58172c0bf36840fade819102da0f246dcdf2"
    sha256 cellar: :any_skip_relocation, monterey:       "1b6030d3be6465d7850db0bc306026c1d21d7d23c7cf12948cbf5a68aa402cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce4c220ea57c03eaa23b1789b72ab2b02b1e2b6f3bec9a563631e358302926c0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end
