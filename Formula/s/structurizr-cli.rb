class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v2024.02.22/structurizr-cli.zip"
  sha256 "76a48bee2016d851a0737bffbbf9aae00d2043e96e1b746ffb7e189ca917b264"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ace545daaa31ccf471b675a0a6ee11e87a63da07afd4378f8a0d4d03d2ba781"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = shell_output("#{bin}/structurizr-cli validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
