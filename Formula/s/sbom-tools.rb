class SbomTools < Formula
  desc "SBOM multi-tool: diff, quality, compliance, vulnerability tracking, VEXes, etc."
  homepage "https://sbom.tools"
  url "https://github.com/sbom-tool/sbom-tools/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "249607a385ae5feeb91637c047827480983b6580fd56cdbeae605de0640b9582"
  license "MIT"
  head "https://github.com/sbom-tool/sbom-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec4f93834feef291420ce786cbfd3c2bd979ae3b1dc26b9d24042efcaf66ee43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16e47546e1be8f788f880c17c01eb4b7b655d7f2f89c98879966a496fe20fafa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd262e5b19b4c73ce402c345afa08047348f4c5ac5b2f5647a5a2b9f37712448"
    sha256 cellar: :any,                 arm64_linux:       "9dbcbc3101387e29e3f85f8d3c20fb2a95dd1d7f7a32a99aa9bc2215343aaa52"
    sha256 cellar: :any,                 x86_64_linux:      "54756796bc4accc036e6c067de800792c85b94212a332e06c1f6b234ef62ba47"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable bin/"sbom-tools", "completions",
                                         shells: [:bash, :zsh, :fish, :pwsh]
    (man1/"sbom-tools.1").write Utils.safe_popen_read(bin/"sbom-tools", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sbom-tools --version") unless build.head?

    (testpath/"old.cdx.json").write <<~JSON
      {
        "bomFormat": "CycloneDX",
        "specVersion": "1.5",
        "components": [
          { "type": "library", "name": "lodash", "version": "4.17.20" }
        ]
      }
    JSON
    (testpath/"new.cdx.json").write <<~JSON
      {
        "bomFormat": "CycloneDX",
        "specVersion": "1.5",
        "components": [
          { "type": "library", "name": "lodash", "version": "4.17.21" },
          { "type": "library", "name": "axios", "version": "1.6.0" }
        ],
        "vulnerabilities": [
          { "id": "CVE-2024-39338", "affects": [{ "ref": "axios" }] }
        ]
      }
    JSON

    output = shell_output("#{bin}/sbom-tools diff old.cdx.json new.cdx.json --fail-on-vuln --output=json", 2)
    expected_component_diff = { "added" => 1, "removed" => 0, "modified" => 1 }
    assert_equal expected_component_diff, JSON.parse(output)["summary"]["components"]
    assert_equal 1, JSON.parse(output)["summary"]["vulnerabilities"]["introduced"]

    output = shell_output("#{bin}/sbom-tools quality old.cdx.json --profile=security --min-score=90", 1)
    assert_match "Grade: F", output

    output = shell_output("#{bin}/sbom-tools validate new.cdx.json --standard=ntia", 1)
    assert_match "NON-COMPLIANT", output
  end
end
