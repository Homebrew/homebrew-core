class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.15.0/structurizr-cli-1.15.0.zip"
  sha256 "f593f1dc36c1d851522ed269041e47a119885ebe4001825ba979b0ef04b9a7f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eac8def454971dc2895f53190738e9a374f2ef60cee4b77bd77866118292d2d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "eac8def454971dc2895f53190738e9a374f2ef60cee4b77bd77866118292d2d6"
    sha256 cellar: :any_skip_relocation, catalina:      "eac8def454971dc2895f53190738e9a374f2ef60cee4b77bd77866118292d2d6"
    sha256 cellar: :any_skip_relocation, mojave:        "eac8def454971dc2895f53190738e9a374f2ef60cee4b77bd77866118292d2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd865a19734d5c5665b5aa1dd568f9da6415e163b138021a5b2e1e8bad795843"
    sha256 cellar: :any_skip_relocation, all:           "7a7b9c7839abd43d50d85385dd979600fcab910da2527b29ca1c54e38b44dc16"
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
