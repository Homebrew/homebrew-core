require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.3.3.tgz"
  sha256 "efbbd17cde56199aafc183fb0c924f4902dce9476cd0db08454ebfa8413e7118"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad558258a15ffb5876459fdcca71cb61f4ce1bcac946899f1fdf8492d58314c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad558258a15ffb5876459fdcca71cb61f4ce1bcac946899f1fdf8492d58314c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad558258a15ffb5876459fdcca71cb61f4ce1bcac946899f1fdf8492d58314c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "dee2f4f27b1bcaed4108aebd0da6a9b1e3445e69fdf8f872d52a56066b0cff11"
    sha256 cellar: :any_skip_relocation, ventura:        "dee2f4f27b1bcaed4108aebd0da6a9b1e3445e69fdf8f872d52a56066b0cff11"
    sha256 cellar: :any_skip_relocation, monterey:       "dee2f4f27b1bcaed4108aebd0da6a9b1e3445e69fdf8f872d52a56066b0cff11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e208b85b7a54ab3f3605751b4ee6ab3bd7d65d65ea42f4acf4a893f1bc6660c5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
