require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.6.4.tgz"
  sha256 "cf47b6af10fa5ed857cb64f29e41228dbde3ac30546f0102ae9c2525172f9631"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e585db40829d1b54341b4cd65f4ba5604e139f830b5ceb484e1a3f34883e35d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e585db40829d1b54341b4cd65f4ba5604e139f830b5ceb484e1a3f34883e35d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e585db40829d1b54341b4cd65f4ba5604e139f830b5ceb484e1a3f34883e35d8"
    sha256 cellar: :any_skip_relocation, ventura:        "1a79ffb8dd1febe56eaedcab8e4eb5832c4c6fb94fcde2194da1f129c6cadc35"
    sha256 cellar: :any_skip_relocation, monterey:       "1a79ffb8dd1febe56eaedcab8e4eb5832c4c6fb94fcde2194da1f129c6cadc35"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a79ffb8dd1febe56eaedcab8e4eb5832c4c6fb94fcde2194da1f129c6cadc35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e585db40829d1b54341b4cd65f4ba5604e139f830b5ceb484e1a3f34883e35d8"
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
      PASS  example

      Tests: 0 failed, 1 passed, 1 total
      Steps: 0 failed, 0 skipped, 1 passed, 1 total
    EOS
    assert_match expected, shell_output("#{bin}/stepci run workflow.yml")

    assert_match version.to_s, shell_output("#{bin}/stepci --version")
  end
end
