class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=storm/apache-storm-2.8.7/apache-storm-2.8.7.tar.gz"
  mirror "https://archive.apache.org/dist/storm/apache-storm-2.8.7/apache-storm-2.8.7.tar.gz"
  sha256 "5a50b02c11e8a67baf8302cc3c9b5b099422fc0d0f076a67f657901748b8a741"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d6a3b9661a824c7fb732079f54bd31bd7259137f619962381ce5a4fb771d6ad"
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
