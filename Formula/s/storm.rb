class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.6.2/apache-storm-2.6.2.tar.gz"
  sha256 "640c2c54a593cdcffef9441336738774ae618830d3e63eb8e770c22d68beed30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15616d19926670cd0b2970ef01e22dfe876f1df751be6089c63451d29d8e2213"
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
