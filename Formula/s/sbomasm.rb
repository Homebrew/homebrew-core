class Sbomasm < Formula
  desc "Tool to assemble and edit SBOMs"
  homepage "https://github.com/interlynk-io/sbomasm"
  url "https://github.com/interlynk-io/sbomasm/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "1d23e648621b6094bcdcbcb0a5443dca403a1fa78f402ae372406b2e9547d7b3"
  license "Apache-2.0"
  head "https://github.com/interlynk-io/sbomasm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed85cd241fc50cb98a64dcdb5ec39224d8075d466c3243ba8d84366fa5db52e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed85cd241fc50cb98a64dcdb5ec39224d8075d466c3243ba8d84366fa5db52e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed85cd241fc50cb98a64dcdb5ec39224d8075d466c3243ba8d84366fa5db52e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fe0387c0d890c32863a2ebc508e492cc6a087bc0102986687a4cd16fe4723e0"
    sha256 cellar: :any,                 x86_64_linux:      "5909311006487615535f208a343b544d920ae636621edc70e33159913cd11f2d"
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

    generate_completions_from_executable bin/"sbomasm", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sbomasm version")

    %w[foo bar].each do |name|
      (testpath/"#{name}.cdx.json").write <<~JSON
        {
          "bomFormat": "CycloneDX",
          "specVersion": "1.6",
          "version": 1,
          "metadata": {
            "component": { "type": "application", "name": "#{name}", "version": "1.0.0" }
          },
          "components": [
            { "type": "library", "name": "lib#{name}", "version": "2.0.0" }
          ]
        }
      JSON
    end

    system bin/"sbomasm", "assemble", "--name=app", "--version=1.0.0", "--type=application",
                          "--output=app.cdx.json", "foo.cdx.json", "bar.cdx.json"
    components = JSON.parse((testpath/"app.cdx.json").read)["components"]
    assert_equal %w[foo bar], components.map { |component| component["name"] }

    output = shell_output "#{bin}/sbomasm edit --subject=document --author='Homebrew (test@brew.sh)' app.cdx.json"
    assert_match '"email": "test@brew.sh"', output
  end
end
