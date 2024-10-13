class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v2024.09.19/structurizr-cli.zip"
  sha256 "acc90f59f5e12ba3faa3d17d49d7bda438f531504b87e271007276f9d9575d9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc1476418ea6db2bd4fc24f3a337341f4f3d44f3d001379c989db07c2d014dcb"
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
