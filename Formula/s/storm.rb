class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.5.0/apache-storm-2.5.0.tar.gz"
  sha256 "fa7dc1b010a84a1ed929d8ed55bfc8a821e06763c6bdcdcf027de5bfac40a8cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "482b4a7846867f12c67552988ccbac61761ed125acfc8651091d66b0cd863c67"
  end

  depends_on "openjdk"
  depends_on "python@3.11"

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
