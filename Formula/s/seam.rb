class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.60.tgz"
  sha256 "e25f9c24234222813d3cbaa152180b61949ef0800f617daba469d297fee5eee8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf7355dabc33a7060c8fd32929e6be4067f2925f1808a9affe9d8a59402c56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf7355dabc33a7060c8fd32929e6be4067f2925f1808a9affe9d8a59402c56a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cf7355dabc33a7060c8fd32929e6be4067f2925f1808a9affe9d8a59402c56a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4b91883ce4c7fc181c743f76a719cedb7d2ecaa111007e98b8ea30d0e8ae16f"
    sha256 cellar: :any_skip_relocation, ventura:       "e4b91883ce4c7fc181c743f76a719cedb7d2ecaa111007e98b8ea30d0e8ae16f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae827f3b1c8531b3c84874292e877970ed0111c2ff0b6ca861673180879a32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf7355dabc33a7060c8fd32929e6be4067f2925f1808a9affe9d8a59402c56a"
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
