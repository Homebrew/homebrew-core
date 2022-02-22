class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.18.tar.gz"
  sha256 "7bfa3ee9ebfef06e880ac1890831255e3f4ba8a20dfab9940d02ce70841e47bd"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8ae8db538ac94979c6907fb0020e128c00b15bc2b4f6254e671e41cf902f7ccd"
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
