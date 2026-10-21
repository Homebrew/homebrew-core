class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "71fe38b652f2a9f89f8ba18dbdd5381b35b8f5d3f7dd7eb5c382908a69ff6f93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a93f927cfd13cfdaa471ef6989099940680c8c58d1a01d7358811db79f1be9c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a93f927cfd13cfdaa471ef6989099940680c8c58d1a01d7358811db79f1be9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a93f927cfd13cfdaa471ef6989099940680c8c58d1a01d7358811db79f1be9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3399976abf61c70d48bee31aa034c64c2b9087943f6e67e94b0f78d116c7d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "daa8ca5f9db9c64005b810862bf7c1327959261febf7068a80409d3517938dfd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
