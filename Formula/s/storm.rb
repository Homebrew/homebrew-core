class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.7.1/apache-storm-2.7.1.tar.gz"
  sha256 "013e44bbeb203a3d41a614cff346bc59c9bd36276b80bb4c7a0832ea8e70dc73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ddc5e302166cb078f6a0503d00c02b2d4e41bb6ee30353bfd91f43d434e766f"
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
