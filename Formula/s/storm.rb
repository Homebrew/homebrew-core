class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.6.1/apache-storm-2.6.1.tar.gz"
  sha256 "20da1d5f00931f95ec8f0b853e1e459002f87c195f65b485951ffd9743668fde"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5ff3d7f0f5266964378fd6748a91f34ea7fb6338f3b3f76d83f9fdad7e58b9d"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

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
