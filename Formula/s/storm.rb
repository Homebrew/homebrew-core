class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=storm/apache-storm-3.2.0/apache-storm-3.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/storm/apache-storm-3.2.0/apache-storm-3.2.0.tar.gz"
  sha256 "7b5faff7d38dd85edf56c919af852e0c8f42244426f5d700c3bbb7c13a841231"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f988945ea44d7b325ea6f41831bb636aa7b7a06d3a6ff6ef6a1efccc6a970b3a"
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
