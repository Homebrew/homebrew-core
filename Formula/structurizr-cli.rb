class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.10.1/structurizr-cli-1.10.1.zip"
  sha256 "e3dd87efc719e8085dcad5330d06894bf5b66348e2625bed9260afb320b08960"
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
      Usage: structurizr push|pull|lock|unlock|export|validate [options]
    EOS
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_equal result, expected_output
  end
end
