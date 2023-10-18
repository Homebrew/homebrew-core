require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.6.8.tgz"
  sha256 "ea54af641198d0048a69740ee7380a4697fde1fab4b1b78e182b4f8c77e7be3b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1a1692455370d55de2ae94a062e1f0ee45774704593c92046726987fa5b8c19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bec57fbe98e6870b11cae1bda25432c94b21bcf8db8f326fb67d681452eb00c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec57fbe98e6870b11cae1bda25432c94b21bcf8db8f326fb67d681452eb00c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bec57fbe98e6870b11cae1bda25432c94b21bcf8db8f326fb67d681452eb00c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fca299465c085c016707c843b8cce4dbeaadc99e27dafecd8d00716320c2f3e"
    sha256 cellar: :any_skip_relocation, ventura:        "9131cd315876209a85f9c0d4ab578256fbc506e7b8f4e889644723c3c823c672"
    sha256 cellar: :any_skip_relocation, monterey:       "9131cd315876209a85f9c0d4ab578256fbc506e7b8f4e889644723c3c823c672"
    sha256 cellar: :any_skip_relocation, big_sur:        "9131cd315876209a85f9c0d4ab578256fbc506e7b8f4e889644723c3c823c672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bec57fbe98e6870b11cae1bda25432c94b21bcf8db8f326fb67d681452eb00c7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://docs.stepci.com/legal/privacy.html
    ENV["STEPCI_DISABLE_ANALYTICS"] = "1"

    (testpath/"workflow.yml").write <<~EOS
      version: "1.1"
      name: Status Check
      env:
        host: example.com
      tests:
        example:
          steps:
            - name: GET request
              http:
                url: https://${{env.host}}
                method: GET
                check:
                  status: /^20/
    EOS

    expected = <<~EOS
      Tests: 0 failed, 1 passed, 1 total
      Steps: 0 failed, 0 skipped, 1 passed, 1 total
    EOS
    assert_match expected, shell_output("#{bin}/stepci run workflow.yml")

    assert_match version.to_s, shell_output("#{bin}/stepci --version")
  end
end
