class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.15.tar.gz"
  sha256 "980f56470d7000cc6c33ede1e98d2a71fda63ab2a269c74fffb141a0d6fd30e8"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "4917537fc324d707919f8fffbce15b779a9a85a5534d9800bcaa2928a5d4ab47"
    sha256 cellar: :any_skip_relocation, catalina:    "3cf1ce30e281fc782c0463c14b6770ff3901a882284942438fb060dd2ebb1120"
    sha256 cellar: :any_skip_relocation, mojave:      "c50a74a7a86bf484bfdb8efcf66a41526b80ebc511af0353093006c2e220a0cc"
    sha256 cellar: :any_skip_relocation, high_sierra: "ed0dbc9e416d425b93070435d5c17620aa81642f9f1b7bca4c76cf4a36b5cdf0"
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
