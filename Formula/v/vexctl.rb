class Vexctl < Formula
  desc "Tool to create, transform and attest VEX metadata"
  homepage "https://openssf.org/projects/openvex/"
  url "https://github.com/openvex/vexctl/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ed77b48de3ead71af608fb3ae5e5f4e19647d87fe9dfe38d4ffce4ee1c1e7c3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a98d2b6408c16612ccb3d1db6ecdda65bbf6b40d4b07adca31dd8704666aafa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a98d2b6408c16612ccb3d1db6ecdda65bbf6b40d4b07adca31dd8704666aafa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a98d2b6408c16612ccb3d1db6ecdda65bbf6b40d4b07adca31dd8704666aafa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9db5167ea7db6957525725f29c57b9a72f0b758ec16f002a44af866e2100e138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdb980c111f359a32bc0597528f517846a2b806cb25b28cf09d3373ec315b47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee7ab65814a907c75c47fede705015488316e2e5d145e9f8822e1c3bc37f6be"
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

    generate_completions_from_executable(bin/"vexctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vexctl version")

    assert_match "Valid Statuses:\n\tnot_affected\n\taffected\n\tfixed\n\tunder_investigation\n",
    shell_output("#{bin}/vexctl list status")
  end
end
