class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.8.1/apache-storm-2.8.1.tar.gz"
  sha256 "6081d52256249d1e597a8671ca4b218d65d2c18c5a6710fba51f5630a36f01a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e61f90dd237a3d49352dd0bcdfcd7fc875fd8a6b8307c4539d77e3482cfd434"
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
