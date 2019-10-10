class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.3.tar.gz"
  sha256 "b1680e3e7e82968182220e07558b56bb060ee0c43e08eb1c31a4fbd8b6ffefa6"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "129e8479886e23a867cb81ff13bbc37da2850f1750a37efb0bfd34a9e1152452" => :mojave
    sha256 "1f6fde47f4028917eaf79eae19d419c8f94c3d660d639ae126d1ad2584c04e02" => :high_sierra
    sha256 "6c81aa47115c200dd87ddf84c2412513c945129830acfe9cacff26efd9882d6c" => :sierra
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
