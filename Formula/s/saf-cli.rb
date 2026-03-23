class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.5.3.tgz"
  sha256 "01c1098a8b1ecf5e417ea0fbc148df36c5bc5b57e7c7a8540e47ba54813b96a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb6a66dcd99c42f7a4b41b8ba29b0f238a8739fb97f274a928bab10f4e2b6330"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "015482e54ebcbb1c0170d99436c2881c98d6ebd1a257647f621d115c2ef81278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "015482e54ebcbb1c0170d99436c2881c98d6ebd1a257647f621d115c2ef81278"
    sha256 cellar: :any_skip_relocation, sonoma:        "df259efaedd70c8aad2f4688005ff323796cc8ed83040e1d6e0a83bb261231a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea21b9afc86a4951ec50b42930ae9aa472fecd2a899f1fb33e00a9255f962916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea21b9afc86a4951ec50b42930ae9aa472fecd2a899f1fb33e00a9255f962916"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mitre/saf/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
