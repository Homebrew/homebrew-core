class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://github.com/structurizr/structurizr/archive/refs/tags/v2026.09.19.tar.gz"
  sha256 "bcf0f09ecd3209c931cce0211f87b914991870364f4321a83c59cf4ecbe40d94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9e26d16c758e796922c3ab737acf4e37f678c3005df9b1eb698b4965a6b9d9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af3ecdd8b21f22eaf62294bfd17a23d1feccb983e0db3cbccac7c4736137d873"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d478a5e40da067427ae043a479b59a0dac7be4ff86ba8216bac6e037ba972162"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "31517d44a930333a1f0990855fbb404c7471814a7b504084607c3d4d5bb6610e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9f280a928fd68d8a03a5662b6ea5212654f12b011e3377cafdca07ccb34bc30a"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "-Dapp.revision=#{version}", "-Dmaven.test.skip=true", "package"
    libexec.install "structurizr-application/target/structurizr-#{version}.war"
    libexec.install "structurizr-mcp/target/structurizr-mcp-#{version}.war"
    bin.write_jar_script libexec/"structurizr-#{version}.war", "structurizr"
    bin.write_jar_script libexec/"structurizr-mcp-#{version}.war", "structurizr-mcp"
    # NOTE: excluding structurizr-themes due to unknown license for PNG files
  end

  test do
    result = shell_output("#{bin}/structurizr validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr: #{version}", shell_output("#{bin}/structurizr version")
  end
end
