require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.8.2.tgz"
  sha256 "0ba4ed74a5f51414b0ed86651e37a1b5e6af4e027187bedfc94dbd2176793178"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e3908fc84c52c88b2a15ef7034e8ca824653cd647ebb1374fcab6a354b12cc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e3908fc84c52c88b2a15ef7034e8ca824653cd647ebb1374fcab6a354b12cc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e3908fc84c52c88b2a15ef7034e8ca824653cd647ebb1374fcab6a354b12cc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "77835aa9e8fea98c91c76937f3a407d44ee8996eee5599f49bc29353941f5d22"
    sha256 cellar: :any_skip_relocation, ventura:        "77835aa9e8fea98c91c76937f3a407d44ee8996eee5599f49bc29353941f5d22"
    sha256 cellar: :any_skip_relocation, monterey:       "77835aa9e8fea98c91c76937f3a407d44ee8996eee5599f49bc29353941f5d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7df98f52a5b404ad257877570bfc89f91d923520bd974e43666d55c9ba03ecc3"
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
