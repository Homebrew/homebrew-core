class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.4.1.tgz"
  sha256 "a45a7cb3ceeaa883fb2073fac29bc396ce3149e1e745a4c415780d7030a40d81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76dc9d3a0327a28cda088e579366734765ecabcccdca12c5332915d88d3dc36a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76dc9d3a0327a28cda088e579366734765ecabcccdca12c5332915d88d3dc36a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76dc9d3a0327a28cda088e579366734765ecabcccdca12c5332915d88d3dc36a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1dc298cbd56095a5e0aa1613015ec2f6ea38e2cb1f2143d5e0fda238e091543f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1dc298cbd56095a5e0aa1613015ec2f6ea38e2cb1f2143d5e0fda238e091543f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
