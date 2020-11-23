class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.5.1/structurizr-cli-1.5.1.zip"
  sha256 "fec5cdb966ec921d694ed6664a38cbb482d97c6610c14126235946e8c83af8ae"
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
      Usage: structurizr push|pull|export [options]
    EOS
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_equal result, expected_output
  end
end
