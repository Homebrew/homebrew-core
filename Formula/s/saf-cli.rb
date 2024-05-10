require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.4.tgz"
  sha256 "434600496a71c829d5cb1d084f932048e173575803d8edaf7bada64d692552ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9619bf70c8e76cabe235c9d1b7d17a66b0631e8aad2fbbecc09195454639fe54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9619bf70c8e76cabe235c9d1b7d17a66b0631e8aad2fbbecc09195454639fe54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9619bf70c8e76cabe235c9d1b7d17a66b0631e8aad2fbbecc09195454639fe54"
    sha256 cellar: :any_skip_relocation, sonoma:         "7219c63390d20fd29b8dba0d62af6a22291d3829e96cbf86285441bade8efc4d"
    sha256 cellar: :any_skip_relocation, ventura:        "7219c63390d20fd29b8dba0d62af6a22291d3829e96cbf86285441bade8efc4d"
    sha256 cellar: :any_skip_relocation, monterey:       "7219c63390d20fd29b8dba0d62af6a22291d3829e96cbf86285441bade8efc4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9619bf70c8e76cabe235c9d1b7d17a66b0631e8aad2fbbecc09195454639fe54"
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
