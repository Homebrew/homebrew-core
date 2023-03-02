class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.38.1.tar.gz"
  sha256 "167de9cc89d6de0161ce04c573f207b42ac09d1e9a472bd0285f28c250cad4f9"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "850b250cd83e71c1b5be5e4d6f2c1567305966c64a1af4850e0df7d2395cda36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "980514c3040e4c2fca4ba938793c97c14744fd154226117fa76a41bec4f9a53f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b34a5b2cb0ead89f61110de032faef4b97c39f32b02f96a7e5b5a18ca179423a"
    sha256 cellar: :any_skip_relocation, ventura:        "f3804fcceb93fb8c95c3a75b8af2723bb9d61c859645c042cbdc58fda93de4ed"
    sha256 cellar: :any_skip_relocation, monterey:       "c63a42a03472333d03236fd9147506e972c24f94ed0f3b04c218737acc6ee466"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f5740f9cb7f6100ecd48fbf2a2865bf1eda055ac2c5f1e62a3b0c7a3e608545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee67d9a10ae323cbd24cec46fc7992ae42e65e0731999632103e62e3f4f40895"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
