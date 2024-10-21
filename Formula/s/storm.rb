class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.7.0/apache-storm-2.7.0.tar.gz"
  sha256 "699402d50c93a2dd15405643d5013fa048b800693d1178b77c8e4b9ae33d7e38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e85b5e93099c2740209d2f689884d7c5af0ec88ce8205d09bef104c02628215"
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
