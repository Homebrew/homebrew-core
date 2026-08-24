class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=storm/apache-storm-3.0.0/apache-storm-3.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/storm/apache-storm-3.0.0/apache-storm-3.0.0.tar.gz"
  sha256 "befcdb1554fea724494d50e934d0a1e60f5a05b5e8a95a5d27ef9be2446087d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98830c99ae66edc7089b33a1f4c5c136327c3b040a021758818627f56fa9be96"
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
