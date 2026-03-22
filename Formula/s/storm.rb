class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=storm/apache-storm-2.8.4/apache-storm-2.8.4.tar.gz"
  mirror "https://archive.apache.org/dist/storm/apache-storm-2.8.4/apache-storm-2.8.4.tar.gz"
  sha256 "fb5060f1a62282bdf45d93fb9ae3da5fb13a5d295159c7cdce5d7aacb8be9a5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05480b09397be822d6b250bd1768b8704976e49e5547d5eee50b0c2e2c58461c"
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
