require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1282.1.tgz"
  sha256 "8e244833a4a2d3fe8ba13f66074c02c0cf5d3cd30afaaf2fb5a0d1ff2535abe4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a43a397611728e3acde9d5b7416e3026386ae0861ae6a5751adee975dc78bc8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d49ae1aa271fb58ff6288ec61705ca967dea8268410a77623e8c4178ce3d7851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67c4f125e6e2f81fdf429f744649e9b8cfb1f158acdaaf9ec66b4ada1bf55388"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9d1dde39ed8641747a79917575337e307cf4856b3474ab665c485cc0afa5890"
    sha256 cellar: :any_skip_relocation, ventura:        "4c392f6385cd3d6c4b17c49a515fce860811ad433bfe97a15bf084d7658f829a"
    sha256 cellar: :any_skip_relocation, monterey:       "8949a6cd600e3a37b3132b543dbfeb26862837c32c9e3b5fac1d4c848a25dee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c4f9a6e292626f591871c4b1a175ab3c45f99479af61447e53c39baa2260fe8"
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
