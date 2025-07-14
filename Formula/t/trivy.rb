class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "9e23c90bd1afd9c369f1582712907e8e0652c8f5825e599850183af174c65666"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60701ca9f0abf3941dc8cb0451da35bc82456898ab9d10ee93542ce833395dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d655525e8f66d5e9545c44296150b24b3c51c1ee11fef11c69f21db8689a578"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10933e6d3696f9acf2399c2b05bc2b511d20f05f52c12f99f8a52274f9b38f11"
    sha256 cellar: :any_skip_relocation, sonoma:        "0209a10a87e67f96598b403ba055c7018286830bb0eeb44c8fff1303ded98276"
    sha256 cellar: :any_skip_relocation, ventura:       "7b02fc4ba2d86428b8319aa23f74daa0992042217d1a07ff5aef5daebcabe922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5ba47eb6ce491c3c5fc0eb4ebdea7ef406046a06756c79064e8402fbc70b816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e20078abd4e6375aed9eca482db028649f8485e8d5ec2eafd093bd21f70575a5"
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
