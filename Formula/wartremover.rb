class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.19.tar.gz"
  sha256 "4eb354ef2def8acbd3ea2b1a6018388c3a096c7337d74c3e2f78c259ee3ac084"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8512b7c15fea2fb28245928d7dfaf9fa41bbcbc53a68d39ca2e1e5d725755ac"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar", "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
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
