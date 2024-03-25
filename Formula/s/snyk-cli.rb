require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1286.0.tgz"
  sha256 "b37299d0dffbca230935db703c97738d7e10eff36cda7f91f13254d36e6ae29e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9070ec4fd21b530c75de994f637f4a0b6254ef663f020ab33bfa78093b229cc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a81546d419e92fb8ea101aa2a8a06ffd42f6ffc05c0cf5fea9a372f5c1dfea23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c02b365ff816ef0e86a4491163871bb7f4ca095bb41ecd462ec284c54a4730f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c3e4d3a0f98fbfe2219a89a1caa5400f90173012f197e13f4af6ff08040d165"
    sha256 cellar: :any_skip_relocation, ventura:        "47ccfab50f11436f324a00862a3f80a03c7ec0196b247656002ce498a38093e9"
    sha256 cellar: :any_skip_relocation, monterey:       "9b1ceaa8265d8800baba40f5a0bbe6492cf5f6b5168d3d47bcd2d890dc595d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "747390e525fa05392ed377be3ad3786a0e429b324a0df7e0b5be5bdfea1c29d8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
