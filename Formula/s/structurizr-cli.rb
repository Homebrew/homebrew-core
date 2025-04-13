class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://docs.structurizr.com/cli"
  url "https://github.com/structurizr/cli/releases/download/v2025.03.28/structurizr-cli.zip"
  sha256 "9bb9073c7387bc4f9c50f33075d87d151ca35aa1bf1b97187fcc19d70dc55dbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a935baf2df03116938057297d49ea51ac342968a59f8ef750afb13dc96449952"
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
