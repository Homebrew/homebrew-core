require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.2.1.tgz"
  sha256 "cb3f738fda80290ee42852fc2113a88e9a9731b1f5caa3648b45d33583bdbe3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e07c3bb7b49b6ac11506936191e7981f45f90ac7018f34bc6bb8af67ed0da96d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e07c3bb7b49b6ac11506936191e7981f45f90ac7018f34bc6bb8af67ed0da96d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e07c3bb7b49b6ac11506936191e7981f45f90ac7018f34bc6bb8af67ed0da96d"
    sha256 cellar: :any_skip_relocation, ventura:        "ed697d0d9b064e46aa84ff50493bff67eb9ec4d64874adc018aa1d54933df959"
    sha256 cellar: :any_skip_relocation, monterey:       "ed697d0d9b064e46aa84ff50493bff67eb9ec4d64874adc018aa1d54933df959"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed697d0d9b064e46aa84ff50493bff67eb9ec4d64874adc018aa1d54933df959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93b0ec3058940c80088175b858448c1cf32f795d83d3e383c2deeab9f573243"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end
