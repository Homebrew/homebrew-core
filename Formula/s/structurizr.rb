class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://github.com/structurizr/structurizr/archive/refs/tags/v2026.06.28.tar.gz"
  sha256 "491a857f41b0378ee3c757e39a2fc45eb0fc4c22d48395b5e154380e478c828c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "115fbeb102140491a77942378350cc8fdbd691f2c631137a2a1c920926d6d55f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c27a2bf1b00e6bcc259fe8d088ca39fc6e66c06c2076197dd8e89edc90869ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "324087b95ec08e3a3fe16c3c54602b46bb961b01afc720f3e57be226ab1cee53"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87ffceb737ca9265f228cea32d4da72c4fbdf6edf36ad6e6c08e12db3847304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6789eb4d38b3a1554b7c076288626b7b9b5fdfab3b91a7baabb774f130192033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "832b621fd1fc2b3b8037b02894dace108f26345430ac97ca2369c6ce9ce6dbbe"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "-Dapp.revision=#{version}", "-Dmaven.test.skip=true", "package"
    libexec.install "structurizr-application/target/structurizr-#{version}.war"
    libexec.install "structurizr-mcp/target/structurizr-mcp-#{version}.war"
    bin.write_jar_script libexec/"structurizr-#{version}.war", "structurizr"
    bin.write_jar_script libexec/"structurizr-mcp-#{version}.war", "structurizr-mcp"
    # NOTE: excluding structurizr-themes due to unknown license for PNG files
  end

  test do
    result = shell_output("#{bin}/structurizr validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr: #{version}", shell_output("#{bin}/structurizr version")
  end
end
