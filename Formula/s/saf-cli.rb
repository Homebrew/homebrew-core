class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.16.tgz"
  sha256 "4f7f1657a8fbdc8f8ba8e4b67db39d05c0b5407f5d85decef8271d8cffff0d7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d1cf33fe660c5c3c0062855b59ce19f5573742bfb023275179328c2e79726e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d1cf33fe660c5c3c0062855b59ce19f5573742bfb023275179328c2e79726e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d1cf33fe660c5c3c0062855b59ce19f5573742bfb023275179328c2e79726e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "efd3337e853dd21e0f6b244127a693e4c70b4e3db17534fd9cec112b92ac63b5"
    sha256 cellar: :any_skip_relocation, ventura:       "efd3337e853dd21e0f6b244127a693e4c70b4e3db17534fd9cec112b92ac63b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d1cf33fe660c5c3c0062855b59ce19f5573742bfb023275179328c2e79726e3"
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
