require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.8.1.tgz"
  sha256 "0206aa0c982f163057da3394e6f3d4c393b06b71189dae8b33476c4054bd55a5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29e324cd9f1694f75c5bb00f29777bfb75615cbed3943ad0f1d6783564f110dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29e324cd9f1694f75c5bb00f29777bfb75615cbed3943ad0f1d6783564f110dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e324cd9f1694f75c5bb00f29777bfb75615cbed3943ad0f1d6783564f110dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f046a0ace725d64e2dce18b845343108259402b7a309dabb0d9da4bf491cbfe2"
    sha256 cellar: :any_skip_relocation, ventura:        "f046a0ace725d64e2dce18b845343108259402b7a309dabb0d9da4bf491cbfe2"
    sha256 cellar: :any_skip_relocation, monterey:       "f046a0ace725d64e2dce18b845343108259402b7a309dabb0d9da4bf491cbfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29e324cd9f1694f75c5bb00f29777bfb75615cbed3943ad0f1d6783564f110dc"
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
