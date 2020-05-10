class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.8.tar.gz"
  sha256 "1ae10c6203e7461ec3d971ddbd19d20f8ca73a38e169c2b0bfbc62115544bacd"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7758b3818708e8ea49a07a03d59135c0065201789deb403c0a35e58caf55186c" => :catalina
    sha256 "9b28a0a36f6b56ec603b155dba923e320b48c19b643ab851c15bfb5e08489a0a" => :mojave
    sha256 "4f20e88cddabec518c215cbdee0a0ca8806e5adbf709cfcc7cb28d89a4428b91" => :high_sierra
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
