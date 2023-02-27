class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.27.0/structurizr-cli-1.27.0.zip"
  sha256 "675646a9e2dd72fc891e193eca7f617880ace60a777cfa4be2383309c0c3f000"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ece2403e7c7a73f6f225493fdc6cd1fedf5adff001a6c94cb65e5d7cd5bdda97"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    # not checking `Structurizr DSL` version as it is different binary
    assert_match "structurizr-cli: #{version}", result
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list|help [options]", result
  end
end
