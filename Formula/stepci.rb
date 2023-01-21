require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.6.3.tgz"
  sha256 "03e724c13242349f71d9e51a6e4c50b91cd195f345404bbbbb29ba3f2289392c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f64208d2e7919625ddfe1126561ae2366c22b5289375743a8451bc7680e2d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f64208d2e7919625ddfe1126561ae2366c22b5289375743a8451bc7680e2d1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f64208d2e7919625ddfe1126561ae2366c22b5289375743a8451bc7680e2d1a"
    sha256 cellar: :any_skip_relocation, ventura:        "0152ecc84d6d75b4f1035e6c7450cff3d3a7534151ad47116f216201c5ed79c3"
    sha256 cellar: :any_skip_relocation, monterey:       "0152ecc84d6d75b4f1035e6c7450cff3d3a7534151ad47116f216201c5ed79c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0152ecc84d6d75b4f1035e6c7450cff3d3a7534151ad47116f216201c5ed79c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f64208d2e7919625ddfe1126561ae2366c22b5289375743a8451bc7680e2d1a"
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
