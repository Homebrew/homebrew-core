class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v2024.03.03/structurizr-cli.zip"
  sha256 "e0cffb88b5b998bbbeae428a463cf001154e82668ce8c61b9f87ccb2743bb1f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1799049eefb8e76f148a8e0329257c0b9957cc6c0898278cab7f77b27c64a362"
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
