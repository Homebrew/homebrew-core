require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.6.2.tgz"
  sha256 "ff1914245604552353f5332ef7abf106c25b2c0b7a1086be75bb5ee3d0d3eea7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e41ea796ca2e6cae06d78d88a3c164906c7c0a64249e99dbb2090a893b98d80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e41ea796ca2e6cae06d78d88a3c164906c7c0a64249e99dbb2090a893b98d80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e41ea796ca2e6cae06d78d88a3c164906c7c0a64249e99dbb2090a893b98d80"
    sha256 cellar: :any_skip_relocation, ventura:        "33aaabc25e3c13545ccd2262d671e030dee0a6851003f000f45044bbf2906fe5"
    sha256 cellar: :any_skip_relocation, monterey:       "33aaabc25e3c13545ccd2262d671e030dee0a6851003f000f45044bbf2906fe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "33aaabc25e3c13545ccd2262d671e030dee0a6851003f000f45044bbf2906fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e41ea796ca2e6cae06d78d88a3c164906c7c0a64249e99dbb2090a893b98d80"
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
