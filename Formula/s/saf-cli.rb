class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.18.tgz"
  sha256 "84181c173ab09a3edbf766c4f7d7c710b9ebe8b460ec7b2d5279e3ffef358255"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b82502f05eae0a29b66e7a854e49e7c6a29b3fa1f54c410b6a6db4bf957eeac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b82502f05eae0a29b66e7a854e49e7c6a29b3fa1f54c410b6a6db4bf957eeac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b82502f05eae0a29b66e7a854e49e7c6a29b3fa1f54c410b6a6db4bf957eeac"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f7ce590bdc17cdbe367594b85a5d5b098b6f77e08d8498917ba924d64bc31e6"
    sha256 cellar: :any_skip_relocation, ventura:       "7f7ce590bdc17cdbe367594b85a5d5b098b6f77e08d8498917ba924d64bc31e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea2f8530b4e3b3c88f7b4d81988f1b4857d0cd10c5bf8f5b96e013d70b348ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
