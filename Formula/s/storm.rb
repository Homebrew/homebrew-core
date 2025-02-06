class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.8.0/apache-storm-2.8.0.tar.gz"
  sha256 "069449d707eb0f44ccdb9a6556f48fd8357b76d089dcc15ad38b778f365c5e7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97e7ce069f5257783d3c493ceede57ae04929a1cc6ecfdf7f564b61f48ba8e3a"
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
