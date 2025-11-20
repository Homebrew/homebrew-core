class Shortest < Formula
  desc "AI-powered natural language end-to-end testing framework"
  homepage "https://github.com/antiwork/shortest"
  url "https://registry.npmjs.org/@antiwork/shortest/-/shortest-0.4.9.tgz"
  sha256 "0e239bceeda97a65178b7e4b6be16cc88c67e047eeb71bfd2da04441156180f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb3317b16f32964930b0dc0800926f935f8b4b8e43587b6c307218000ff8bdb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb3317b16f32964930b0dc0800926f935f8b4b8e43587b6c307218000ff8bdb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3317b16f32964930b0dc0800926f935f8b4b8e43587b6c307218000ff8bdb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b1d99746d550614d0d529edf8a185e30f5af518e1c1013d1f89e50dce1a2ccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91ca37e8ada7364de9a79f531762d0ef3abbfca5117c5de66efa702816c18bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab31d829a0e0de264d83636e041d73e5c8e01c9f7e6081921a26905509a75f0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["GITHUB_TOTP_SECRET"] = "test"

    assert_match version.to_s, shell_output("#{bin}/shortest --version")

    output = shell_output("#{bin}/shortest github-code")
    assert_match "GitHub 2FA Code", output
  end
end
