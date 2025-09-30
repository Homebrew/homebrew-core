class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "3ac0c6dd272ac1f2e2b9bf5f75a90fe0cf9237c3c4650ffa04b440c2ba145cc4"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3353ab7c7b31738518f0623baebdd5147e8f31d135cdfdf38d1898d54dbf375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09ebc9eab1fabc629904918a7ec05ac1c823efc0f5472e46f3532a24a0ec4b80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85634db1e4d46abc1a053da6bb244ec11fd651ddee764a5f367345dd67e98432"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49ce40e8fe379fe61d2947cf63eebaa3c8a587f62c0100d31ce71054e3a171c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7faa0d770e15cccbe0b570d320a6bec5e5c307673f7a45f1dcd6c75e9d6e6a7d"
    sha256 cellar: :any_skip_relocation, ventura:       "115f92073680abfbf7bf4e34fee56e738609a41def681c87d2ffea8662ebfe27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d13576d957aa65948b7ed13c8c8acc74ec04958458715afe2a724755e381dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae64349c615431a550413ade4e4ebc30043eab9690c303ee3fb9445df40e333d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
