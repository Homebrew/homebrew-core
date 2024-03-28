require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.55.tgz"
  sha256 "ce344169eed14ffd47e17a40cefa94634b3176357ea984175f5eaab02cd689e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e084de98cf306b156dcb518ca77131cc125e8b49fb7835565071e6d83605d15d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e084de98cf306b156dcb518ca77131cc125e8b49fb7835565071e6d83605d15d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e084de98cf306b156dcb518ca77131cc125e8b49fb7835565071e6d83605d15d"
    sha256 cellar: :any_skip_relocation, sonoma:         "205c032e3f497500a28802e94e27d599b9e7bb1b9e8eae5b0bf46ca634aeb7c1"
    sha256 cellar: :any_skip_relocation, ventura:        "205c032e3f497500a28802e94e27d599b9e7bb1b9e8eae5b0bf46ca634aeb7c1"
    sha256 cellar: :any_skip_relocation, monterey:       "205c032e3f497500a28802e94e27d599b9e7bb1b9e8eae5b0bf46ca634aeb7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e084de98cf306b156dcb518ca77131cc125e8b49fb7835565071e6d83605d15d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end
