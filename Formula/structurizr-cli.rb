class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.13.0/structurizr-cli-1.13.0.zip"
  sha256 "f40385ab5b06428ba07bb4a7d19aaf90ae8e54a70716bfcb2236084e60c43c9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "577c63bd2b048a11b1a33764323cb5175ad4c68a2b2fc097cba355c6d20f4409"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    expected_output = <<~EOS.strip
      Structurizr CLI v#{version}
      Structurizr DSL v#{version}
      Usage: structurizr push|pull|lock|unlock|export|validate|list [options]
    EOS
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_equal result, expected_output
  end
end
