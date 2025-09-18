class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "7d23eebcbadb9e22b56949c0320ac9a3a6055dc7e8d750bb84583a196fa8d2eb"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abc81151c14052794caa8c926e442c64cd5a015da0afff03432a3eaa83e85e91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8badbb0373b9ae4d3b1a158bde6dd0fbe11f9bd19e37ac2ce24eb2afcb96f324"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3f82712e0ff75d0377706bdcbfb3b18bf068722e2349fb63554a0b38377369c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41673fc6b52ed2cc84cd0f810aa74d83178b7f220ac545f546d6a73983cdc0d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd0547e62694755bb3939bf6b1c59edec97ce49c1b15e401c66d4e9c2bef0d7"
    sha256 cellar: :any_skip_relocation, ventura:       "5838c73e628351c3b6eedf65d3d33532b0ce6d7601ed1d1ddee5b60cb7d007d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6f710f5a932c25c6c8d401432a25381770c697e17b4f841ef4960b876f07f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v3/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"2ms"), "main.go"
  end

  test do
    version_output = shell_output("#{bin}/2ms --version 2>&1")
    assert_match version.to_s, version_output

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end
