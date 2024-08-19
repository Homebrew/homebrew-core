class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.6.3/apache-storm-2.6.3.tar.gz"
  sha256 "79e6ffade8cfa1185bd00836e3f300cff88d830eb070ea2ec217442d1143d316"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49413ea2ae2e639562f993bc53759064f5f58ad3b0ef9a6c7970b291c71359a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49413ea2ae2e639562f993bc53759064f5f58ad3b0ef9a6c7970b291c71359a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49413ea2ae2e639562f993bc53759064f5f58ad3b0ef9a6c7970b291c71359a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "49413ea2ae2e639562f993bc53759064f5f58ad3b0ef9a6c7970b291c71359a6"
    sha256 cellar: :any_skip_relocation, ventura:        "49413ea2ae2e639562f993bc53759064f5f58ad3b0ef9a6c7970b291c71359a6"
    sha256 cellar: :any_skip_relocation, monterey:       "49413ea2ae2e639562f993bc53759064f5f58ad3b0ef9a6c7970b291c71359a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c2eb54566fbfa46638747a9b200b7ebdc4e0b605184300ff6df59413d8e3ed6"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"storm").write_env_script libexec/"bin/storm", Language::Java.overridable_java_home_env
    rewrite_shebang detected_python_shebang, libexec/"bin/storm.py"
  end

  test do
    system bin/"storm", "version"
  end
end
