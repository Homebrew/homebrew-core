class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.8.1/structurizr-cli-1.8.1.zip"
  sha256 "98af6c614fc826a8bf493c3f0936205ea315aef91402c11233de87e0c9f59b87"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "structurizr-cli-#{version}.jar"
    bin.write_jar_script libexec/"structurizr-cli-#{version}.jar", "structurizr-cli"
  end

  test do
    expected_output = <<~EOS.strip
      Structurizr CLI v#{version}
      Usage: structurizr push|pull|lock|unlock|export [options]
    EOS
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_equal result, expected_output
  end
end
