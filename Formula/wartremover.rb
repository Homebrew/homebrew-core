class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.9.tar.gz"
  sha256 "98fc15dfa9cd1da06116a8ea22413c021f1542547ada5985dc92336bca42208e"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b035124c934d0df9387b761b5072207b1d1dc0b1191b4e5e56accfa3c70b3eaf" => :catalina
    sha256 "b8625d2e85cbaa9dc94398f40d80d3ff864e7982e6dba4d1316c5299d229a484" => :mojave
    sha256 "9e22985585006d2ed0cac559dd8c1af5b77072cfe5a3a98f97563c1aa6afe145" => :high_sierra
  end

  depends_on "sbt" => :build
  depends_on :java => "1.8"

  def install
    system "./sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar",
                    "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover", :java_version => "1.8"
  end

  test do
    (testpath/"foo").write <<~EOS
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end
