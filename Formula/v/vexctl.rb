class Vexctl < Formula
  desc "Tool to create, transform and attest VEX metadata"
  homepage "https://openssf.org/projects/openvex/"
  url "https://github.com/openvex/vexctl/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ed77b48de3ead71af608fb3ae5e5f4e19647d87fe9dfe38d4ffce4ee1c1e7c3b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2c5b287cf8b296ef3e6d85b38212179eebea16f070bfce1baea6ac0d119e7cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c5b287cf8b296ef3e6d85b38212179eebea16f070bfce1baea6ac0d119e7cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c5b287cf8b296ef3e6d85b38212179eebea16f070bfce1baea6ac0d119e7cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcae34a87491e8efef1aa942274facd1fc985f36e76cf6b9671e4b0d66738335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1adeeacdaf6ad3a33abafc10856dc356bfab928a5a18de8cfa69a015ad18f7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9053ff8fcb65e7f520118e1d2a02dd377a0a9951b5dc3f4a667e640e81eb919"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vexctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vexctl version")

    assert_match "Valid Statuses:\n\tnot_affected\n\taffected\n\tfixed\n\tunder_investigation\n",
    shell_output("#{bin}/vexctl list status")
  end
end
