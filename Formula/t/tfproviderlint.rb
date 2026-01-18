class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://github.com/bflad/tfproviderlint/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "9defa750077052ebf1639532e771a9e986b7a53948b6a16cb647ceaf60cfbce1"
  license "MPL-2.0"
  revision 1
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f4bf27d9b61e145f042c164ed14a9a3a01ce9b9caaafabd14dd91764b6f7014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ed7fe0393b6cc3591ca9dbcce920c84698ff11ab9446e29e93888a67a494f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ed7fe0393b6cc3591ca9dbcce920c84698ff11ab9446e29e93888a67a494f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7ed7fe0393b6cc3591ca9dbcce920c84698ff11ab9446e29e93888a67a494f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ff646a23f8738c5e0b3dcb848c09b1125182d03e0d7925d58927bb6b066f36"
    sha256 cellar: :any_skip_relocation, ventura:       "a6ff646a23f8738c5e0b3dcb848c09b1125182d03e0d7925d58927bb6b066f36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a31f564bfe6ecb8bb9ac76043141bf54674b05d51ef4c0df2cfa964fdf25742c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45dcc2992373e36bd948f80f3a4e9db317c4d209ee2e449c476fbd1e4490854c"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/bflad/tfproviderlint/version.Version=#{version}
      -X github.com/bflad/tfproviderlint/version.VersionPrerelease=#{"dev" if build.head?}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tfproviderlint"
  end

  test do
    resource "homebrew-test_resource" do
      url "https://github.com/russellcardullo/terraform-provider-pingdom/archive/refs/tags/v1.1.3.tar.gz"
      sha256 "3834575fd06123846245eeeeac1e815f5e949f04fa08b65c67985b27d6174106"
    end

    testpath.install resource("homebrew-test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output("#{bin}/tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output("#{bin}/tfproviderlint --version")
  end
end
