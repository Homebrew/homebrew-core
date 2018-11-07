class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.3.7.tar.gz"
  sha256 "7a418ec9cd5fddb8499b6e1551071be0553cd66c63378107e3e561c47ce421ca"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62250dfd9d2dc313300694536ea040acdb2931ce37c696cad28d7690bb148772" => :mojave
    sha256 "84d65bf6808a6683b8e41cfc167232590094433b6d316c19f800da2253d8cc2e" => :high_sierra
    sha256 "c7278d256a0bbedd1d1e7926768b8082898183fa7b18c7887340222b54cdf98e" => :sierra
    sha256 "e11fd32c7e9f8aab1bbb1da9bb13f01bb0015d0a5ba55bc2c5373af18364ea2d" => :el_capitan
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
