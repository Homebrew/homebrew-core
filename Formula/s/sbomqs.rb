class Sbomqs < Formula
  desc "SBOM quality scorer and compliance checker"
  homepage "https://github.com/interlynk-io/sbomqs"
  url "https://github.com/interlynk-io/sbomqs/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "2e4f33a976594216b766be48b64c3af8484c7c9588cee9baf364fbcd2470eccb"
  license "Apache-2.0"
  head "https://github.com/interlynk-io/sbomqs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ca1488845f7c4fe1d56f969fe3ffbabc29c92c9734c9075fca385011d3a6573"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ca1488845f7c4fe1d56f969fe3ffbabc29c92c9734c9075fca385011d3a6573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ca1488845f7c4fe1d56f969fe3ffbabc29c92c9734c9075fca385011d3a6573"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b92a9f132f8b85c8a55698847f85ec4fcc5f289f848e5d4bd6c77722210ac454"
    sha256 cellar: :any,                 x86_64_linux:      "253eb5cc404db3f320cbd725473351163ecf930e890f4ff57936065ac247f423"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{build.head? ? Utils.git_head : tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable bin/"sbomqs", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sbomqs version")

    (testpath/"sbom.cdx.json").write <<~JSON
      {
        "bomFormat": "CycloneDX",
        "specVersion": "1.6",
        "version": 1,
        "metadata": {
          "component": { "type": "application", "name": "app", "version": "1.0.0" }
        },
        "components": [
          { "type": "library", "name": "libfoo", "version": "2.0.0", "purl": "pkg:generic/libfoo@2.0.0" }
        ]
      }
    JSON

    # Only one of the two components has a PURL
    output = shell_output "#{bin}/sbomqs score --feature=comp_with_purl sbom.cdx.json"
    assert_match "5.0/10.0", output

    output = shell_output "#{bin}/sbomqs compliance --ntia sbom.cdx.json"
    assert_match "pkg:generic/libfoo@2.0.0", output
  end
end
