class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "922f2e818849201df66fecdc9cf8b5f5d315130e476c1460621ab447db7d744f"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57802fb438201e58f08be890a6873393d8ea0627cb51971cff2006f1ae60d084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8293e387e65a0b79b6f49460a8967af55e72eb7470bfbc44c061b2e22a39046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a8bf60960284c1abc84cd07076b6162a946a956b086fb3f9e75fc8812fae387"
    sha256 cellar: :any_skip_relocation, sonoma:        "96bd4baac5eee6925a657afc959af9ac226820b8465cd7f72fd66a63222b0f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62ff10b30a6381d99de5149c5ef37ff622b28c0fc3a5957e983595e67f2daf6f"
    sha256 cellar: :any,                 x86_64_linux:  "5ed315b45e304a21151cc52a3f3569b5b818a3d93c2e3a5393b8decdfa91ebbb"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
