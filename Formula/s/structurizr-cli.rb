class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://docs.structurizr.com/cli"
  url "https://github.com/structurizr/cli/releases/download/v2025.11.09/structurizr-cli.zip"
  sha256 "f5365a463fc44d539ed19bec00c48ba1e1ecda0ccfd1ba40d2e7472d264eb79a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0825af5401fa205d327c343adbbae0868cf9c0c91ec83182110a99f62239a8aa"
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
