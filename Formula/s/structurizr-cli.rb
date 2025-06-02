class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://docs.structurizr.com/cli"
  url "https://github.com/structurizr/cli/releases/download/v2025.05.28/structurizr-cli.zip"
  sha256 "bbe87f7bdcc272755e0bc056fe1641dc4e95d263f109e6733daea96d8acdadc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2e906d447ee8cab70797e0dc00db2527e1408bf371cb2094c94b5f03e762152"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = shell_output("#{bin}/structurizr-cli validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
