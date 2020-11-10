class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.13.tar.gz"
  sha256 "d8fb123dc4f9327adf17e4a59c6004e6eece840725175968049d6d9f3b3e545e"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2272e206adb7c11369c476e6d11b227bb7e3034e1141d414801970c330686db" => :catalina
    sha256 "84c9d2fa3e0ee16d4983647a33f045d3fc4a5e11c3722458963451f5adff3c5a" => :mojave
    sha256 "db7876a7fca960bb215d2509f74b4233579d7e6499dddb38eac5446393129f4a" => :high_sierra
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
