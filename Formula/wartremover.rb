class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.5.tar.gz"
  sha256 "83f86654e245f10b0d2666675250559cfb3ef9a98b09a11739334762d7b889f4"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1072a005bc1a6592f8b78e7a96d7ea6406da61027a7fbd6d58e16f226d956879" => :catalina
    sha256 "fa992ea76ca474f2a1897713eb0a1a850f2b28927aee118bac82fa69d99a10bb" => :mojave
    sha256 "be2e41e936d7a5f78f1d242f958d4a6cd4c563a52fd599c8be0adb619eed4828" => :high_sierra
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
