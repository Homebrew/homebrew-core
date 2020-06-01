class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.9.tar.gz"
  sha256 "98fc15dfa9cd1da06116a8ea22413c021f1542547ada5985dc92336bca42208e"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4768dff77c54a336e206eb22b2c86d58cec941af9f07f2f0c172187edc9a84e9" => :catalina
    sha256 "4099aeba976a9063b6c50d8bf019e649425a6921f658fbc901ac619f59c6f843" => :mojave
    sha256 "465e0d8d288697c9a72f3d1122720d97856c892f5d8cc3e830ea81336441de43" => :high_sierra
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
