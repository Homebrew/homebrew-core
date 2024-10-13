class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.15.tgz"
  sha256 "1d4d1c0ab94f7b86dd772ee8167f34e730432a52b8a0d0972077ee290e3e179a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c2a517175584071429f989b8dd120991d302962f8ba774a1fbca8ea5434b2aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c2a517175584071429f989b8dd120991d302962f8ba774a1fbca8ea5434b2aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c2a517175584071429f989b8dd120991d302962f8ba774a1fbca8ea5434b2aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ae5c83812d68f4b9019176e3d00c56a1e0090e1f4c5b6877c6f99e811c6bd3d"
    sha256 cellar: :any_skip_relocation, ventura:       "2ae5c83812d68f4b9019176e3d00c56a1e0090e1f4c5b6877c6f99e811c6bd3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2a517175584071429f989b8dd120991d302962f8ba774a1fbca8ea5434b2aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
