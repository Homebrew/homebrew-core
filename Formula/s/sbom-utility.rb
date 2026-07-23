class SbomUtility < Formula
  desc "Tool to validate, analyze, query and edit Software Bills of Materials (SBOMs)"
  homepage "https://github.com/CycloneDX/sbom-utility"
  url "https://github.com/CycloneDX/sbom-utility/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "e1f49f1c69d231f19a16085a56ad187700cf712287412182442d6f1b000fd77e"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/sbom-utility.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f007f8c7f74412af69ca172963772a13d642e1781f8952374236cab1e7d727e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f007f8c7f74412af69ca172963772a13d642e1781f8952374236cab1e7d727e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f007f8c7f74412af69ca172963772a13d642e1781f8952374236cab1e7d727e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5043e026f2fa13387e65c0cb95395558dd8c401e2b6407767862939ac40b50b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fa869c09216f41a2f034933ec94ad9dac9fe4283a44792b127670810ec70a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dffa5b515f5f05d9001f3a5111148cb41f4816c5412abee43c9da1cb0fa356a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.Binary=sbom-utility
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable bin/"sbom-utility", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sbom-utility version")

    (testpath/"bom.json").write <<~JSON
      {
        "bomFormat": "CycloneDX",
        "specVersion": "1.6",
        "version": 1,
        "metadata": {
          "component": { "type": "application", "name": "test-app", "version": "1.0.0" }
        },
        "components": [
          { "type": "library", "name": "test-lib", "version": "2.3.4" }
        ]
      }
    JSON

    system bin/"sbom-utility", "validate", "--input-file", "bom.json"

    output = shell_output("#{bin}/sbom-utility query --input-file bom.json --from metadata.component")
    component = JSON.parse(output.gsub(/^\[INFO\].*\n/, ""))
    assert_equal "test-app", component["name"]
    assert_equal "1.0.0", component["version"]

    assert_match "test-lib", shell_output("#{bin}/sbom-utility resource list --input-file bom.json")
  end
end
