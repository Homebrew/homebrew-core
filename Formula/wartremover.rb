class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.13.tar.gz"
  sha256 "d8fb123dc4f9327adf17e4a59c6004e6eece840725175968049d6d9f3b3e545e"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4917537fc324d707919f8fffbce15b779a9a85a5534d9800bcaa2928a5d4ab47" => :big_sur
    sha256 "3cf1ce30e281fc782c0463c14b6770ff3901a882284942438fb060dd2ebb1120" => :catalina
    sha256 "c50a74a7a86bf484bfdb8efcf66a41526b80ebc511af0353093006c2e220a0cc" => :mojave
    sha256 "ed0dbc9e416d425b93070435d5c17620aa81642f9f1b7bca4c76cf4a36b5cdf0" => :high_sierra
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
