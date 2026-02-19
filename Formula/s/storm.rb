class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.8.3/apache-storm-2.8.3.tar.gz"
  sha256 "5bb6bfe2f2601a1880c64d25fb58d8fb7f0ca73f1638ba1d8655ba97a9d01c47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18c64ba42280e7533e27aa5c7ba404c39d244805bf0dd5eb9a5b2eae9bf1f83c"
  end

  depends_on "openjdk"

  uses_from_macos "python"

  def install
    libexec.install Dir["*"]
    (bin/"storm").write_env_script libexec/"bin/storm", Language::Java.overridable_java_home_env
    rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec/"bin/storm.py"
  end

  test do
    system bin/"storm", "version"
  end
end
