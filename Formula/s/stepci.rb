class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.8.2.tgz"
  sha256 "0ba4ed74a5f51414b0ed86651e37a1b5e6af4e027187bedfc94dbd2176793178"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5734ebe30193bf703e1e8abf64b3c3085dfbbc3be250494fbae9607b81a42ca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b51a4218cbf325447634057a0362fa99de98611348196764ba954f53baeb2eba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b51a4218cbf325447634057a0362fa99de98611348196764ba954f53baeb2eba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b51a4218cbf325447634057a0362fa99de98611348196764ba954f53baeb2eba"
    sha256 cellar: :any_skip_relocation, sonoma:         "c59c4b4fa04b0d69872f8bbe4a27a0b1313afcc689b4ac00104963f540fcfad7"
    sha256 cellar: :any_skip_relocation, ventura:        "c59c4b4fa04b0d69872f8bbe4a27a0b1313afcc689b4ac00104963f540fcfad7"
    sha256 cellar: :any_skip_relocation, monterey:       "c59c4b4fa04b0d69872f8bbe4a27a0b1313afcc689b4ac00104963f540fcfad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "85b84fadcf625233e1794dcc32f0affbcd515bf224efee8287b24f42a341d313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f06503b493bdddd590715fc784086f1c9a4241c67450af3f07cd4077099d581a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://docs.stepci.com/legal/privacy.html
    ENV["STEPCI_DISABLE_ANALYTICS"] = "1"

    (testpath/"workflow.yml").write <<~YAML
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
    YAML

    expected = <<~EOS
      Tests: 0 failed, 1 passed, 1 total
      Steps: 0 failed, 0 skipped, 1 passed, 1 total
    EOS
    assert_match expected, shell_output("#{bin}/stepci run workflow.yml")

    assert_match version.to_s, shell_output("#{bin}/stepci --version")
  end
end
