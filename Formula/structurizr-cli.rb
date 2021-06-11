class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.11.0/structurizr-cli-1.11.0.zip"
  sha256 "c07547da5a96ee764de1501f3d1488ca1b02f481bc669e2ad7c55aa0c6208a4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "976f8cd526e9302424ec259c10bddb8dcfa83fd8920bb5feb43d4ae4e87b386d"
  end

  depends_on "openjdk"

  def install
    libexec.install "structurizr-cli-#{version}.jar"
    bin.write_jar_script libexec/"structurizr-cli-#{version}.jar", "structurizr-cli"
  end

  test do
    expected_output = <<~EOS.strip
      Structurizr CLI v#{version}
      Usage: structurizr push|pull|lock|unlock|export|validate|list [options]
    EOS
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_equal result, expected_output
  end
end
