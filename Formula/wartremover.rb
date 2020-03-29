class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.5.tar.gz"
  sha256 "83f86654e245f10b0d2666675250559cfb3ef9a98b09a11739334762d7b889f4"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac3bc25e5234c527c546bfab1fc29df52da43952204c7fae60ed6dec0321d8ba" => :catalina
    sha256 "56ecdad938589a0664837a7dc48b6d90adc5e24c4481ee1046b22c384bab013b" => :mojave
    sha256 "bb2a05744eaea5b65952c50f1e7fed70c9755ed268fe07618aa842e16e61aac7" => :high_sierra
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
