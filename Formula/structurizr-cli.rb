class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.8.0/structurizr-cli-1.8.0.zip"
  sha256 "f5352d0b4cb2dc14fbd314ac64588103ca3e8d1bd407714a2acd392c9ce4d8aa"
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
