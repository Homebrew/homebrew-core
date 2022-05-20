class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.4.0/apache-storm-2.4.0.tar.gz"
  sha256 "54535c68848f05130647997f3fafe91a72bb9470a50d6d80997274d20cf1c0c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4cf6f7e7246a6d806f367ccf82398437f9938e66e79e1b8e00d7f40a29b9f944"
  end

  depends_on "openjdk"
  depends_on "python@3.10"

  conflicts_with "stormssh", because: "both install 'storm' binary"

  def install
    libexec.install Dir["*"]
    (bin/"storm").write_env_script libexec/"bin/storm", Language::Java.overridable_java_home_env
    rewrite_shebang detected_python_shebang, libexec/"bin/storm.py"
  end

  test do
    system bin/"storm", "version"
  end
end
