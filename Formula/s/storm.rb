class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=storm/apache-storm-3.1.0/apache-storm-3.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/storm/apache-storm-3.1.0/apache-storm-3.1.0.tar.gz"
  sha256 "4fd7853462cb591e94dc594f95effe8e107842d8d6041482cc0b3e01ece5198c"
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
