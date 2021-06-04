class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.15.tar.gz"
  sha256 "980f56470d7000cc6c33ede1e98d2a71fda63ab2a269c74fffb141a0d6fd30e8"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "01e5f3a7df0d0565a77eb618f0e8096f61c1f638a5eacd91d8d9aaadff210fce"
    sha256 cellar: :any_skip_relocation, catalina: "56415ad54c5ea4cfe7c031408a49e06d5bc971cc767f5e0df2c177be41d6b705"
    sha256 cellar: :any_skip_relocation, mojave:   "92d53eea1122fd6bf2d55983ed52751a436da82050bb4078fa68b4cc3f45b3df"
  end

  depends_on "sbt" => :build
  depends_on "openjdk@8"

  def install
    system "sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar",
                    "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover", java_version: "1.8"
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
