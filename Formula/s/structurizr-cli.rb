class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.33.1/structurizr-cli-1.33.1.zip"
  sha256 "c42c32b50dedb2cb11d3960a9257e2b820bbebcc7c444fd0e147b1b896141406"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "faa596fbcaa453d5b7b9fa3e315883fe36c5940212c538bb773ee45e8adcd46c"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list|version|help [options]", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
