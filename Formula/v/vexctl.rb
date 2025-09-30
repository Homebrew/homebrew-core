class Vexctl < Formula
  desc "Tool to create, transform and attest VEX metadata"
  homepage "https://openssf.org/projects/openvex/"
  url "https://github.com/openvex/vexctl/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "717ba3570aa2ac7db54823e042d8e7c525a10850879585edb7ca859dee966114"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "673e84ca835091407a39e79677d88ba7daa63564cd3de003902a89f350f140c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "673e84ca835091407a39e79677d88ba7daa63564cd3de003902a89f350f140c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "673e84ca835091407a39e79677d88ba7daa63564cd3de003902a89f350f140c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4602c986ab98ee1ce5faab2db2f4f181464e6ffb38bc275f7b1f504e0e310d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7e88cc3dec4cedde682d50f2cb5be6faad6a0639ee4efbfd183872e0bdc637"
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
