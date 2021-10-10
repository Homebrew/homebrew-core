class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.15.0/structurizr-cli-1.15.0.zip"
  sha256 "f593f1dc36c1d851522ed269041e47a119885ebe4001825ba979b0ef04b9a7f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04d0f157a2d7f4efaca1a67d95a32bde8e671c539dc1f916d896789f18a50b4b"
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
