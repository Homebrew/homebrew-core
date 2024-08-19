class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v2024.07.03/structurizr-cli.zip"
  sha256 "d419e5221f3c8dbb1f92bda7420094905a1f6c651184dc49abb119f203de5e96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84ed277ef96b4c4dfac7da213606e67eb369eb0412cac05c1dd109dfceda257b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84ed277ef96b4c4dfac7da213606e67eb369eb0412cac05c1dd109dfceda257b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84ed277ef96b4c4dfac7da213606e67eb369eb0412cac05c1dd109dfceda257b"
    sha256 cellar: :any_skip_relocation, sonoma:         "84ed277ef96b4c4dfac7da213606e67eb369eb0412cac05c1dd109dfceda257b"
    sha256 cellar: :any_skip_relocation, ventura:        "84ed277ef96b4c4dfac7da213606e67eb369eb0412cac05c1dd109dfceda257b"
    sha256 cellar: :any_skip_relocation, monterey:       "84ed277ef96b4c4dfac7da213606e67eb369eb0412cac05c1dd109dfceda257b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce28e4542a4cca86165691e7146a083c80e3495f528abc309489e8590f929ed9"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = shell_output("#{bin}/structurizr-cli validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
