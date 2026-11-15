class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.7.0.tgz"
  sha256 "001d6bdb2ca7462ac86b5544068f7d2bf415cda777c6ef6ce3e1bd83af31269a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d59e8fa9b65668649a5dab2088fae156ac00641ca5f849a370893495d14a141a"
    sha256 cellar: :any,                 arm64_tahoe:       "9056b3200097983f6a6442c90dfc9ac480d15518c74b97f675cefafdf9b0cafc"
    sha256 cellar: :any,                 arm64_sequoia:     "9056b3200097983f6a6442c90dfc9ac480d15518c74b97f675cefafdf9b0cafc"
    sha256 cellar: :any,                 arm64_sonoma:      "9056b3200097983f6a6442c90dfc9ac480d15518c74b97f675cefafdf9b0cafc"
    sha256 cellar: :any,                 sonoma:            "5d08267d3837efaccfd8f97750a3f97c512a9e766a5d9dd892fc612669ffe375"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "657b22f97ac03eb4f247e3b7e3a37a7cc4ffaf44ad7ca3ada0ccee6d6baca9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3c39e0e861a129cc019b1fe2baa58091ad25198f78c85d5efaf3edc805a347e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
