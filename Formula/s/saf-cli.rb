require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.0.tgz"
  sha256 "ca6420e25872210ec4ff064fbb066ea6af9936eb8e4743eb9ae388f33ba81530"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "487170d42db37cc7f8599784d0390258719df9842f80b28115cc9869de5bc30b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "487170d42db37cc7f8599784d0390258719df9842f80b28115cc9869de5bc30b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "487170d42db37cc7f8599784d0390258719df9842f80b28115cc9869de5bc30b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd931198fdd9bb3fd0fea2c69639e4049bf7de003a4f7d9fc576820b2a90bc27"
    sha256 cellar: :any_skip_relocation, ventura:        "cd931198fdd9bb3fd0fea2c69639e4049bf7de003a4f7d9fc576820b2a90bc27"
    sha256 cellar: :any_skip_relocation, monterey:       "cd931198fdd9bb3fd0fea2c69639e4049bf7de003a4f7d9fc576820b2a90bc27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dabdb5ab8cad0f57cee0d609d9c9d307cb04b4e68fbfc00e70a1d101a584589"
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
