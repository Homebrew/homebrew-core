class SbomTools < Formula
  desc "SBOM multi-tool: diff, quality, compliance, vulnerability tracking, VEXes, etc."
  homepage "https://sbom.tools"
  url "https://github.com/sbom-tool/sbom-tools/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0d5594bb6c4698afce319c62a09198df8826cc701dbbe522ef0a5ef09cc1649e"
  license "MIT"
  head "https://github.com/sbom-tool/sbom-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70661b3a3a7883b5bdb5f23401430e74d2f331aeecdfcdee909aa61cf553fe5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10161501c7fa2102f0418cbfdffdf9f10251f005c978ea6698b054e29608eff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfb6ffa028471bc80ff6df8fdbaae4adb71e2e93036e35c09e02e4df556f0a87"
    sha256 cellar: :any,                 arm64_linux:       "756acbd2d71b40f6f4f927a5393d5da9633c0dc3d014b5ab7ecd8f7affe031c2"
    sha256 cellar: :any,                 x86_64_linux:      "b2605fe242ee44b08e314c6ea74ca52ab13fac990c81e197e61f10898abd2749"
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
