class Senzu < Formula
  desc "Tool to get the battery percentage"
  homepage "https://github.com/Hakky54/senzu"
  url "https://github.com/Hakky54/senzu/archive/refs/tags/1.0.2.tar.gz"
  sha256 "eb67e43be37da798acb975ca99d93743fe6456afb1acc1822c320243bae891de"
  license "Apache-2.0"

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "clean", "package", "-DskipTests=true"
    libexec.install "target/senzu.jar"
    bin.write_jar_script libexec/"senzu.jar", "senzu"
  end

  test do
    output = shell_output("#{bin}/senzu -V")
    assert_includes output, "Senzu v"
  end
end
