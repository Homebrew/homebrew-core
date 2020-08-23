class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.10.tar.gz"
  sha256 "004d129ba91004fb7cb16e997b25db56803812a7e2e762a48b4653039e5b0f6c"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b092885db652f89041bf7c2268d0a9ebea694c275da3e77bcd83d406120dbd22" => :catalina
    sha256 "4841ba4a2275d986f10274dc4bb151f738661373b52dab548e8980989b16e607" => :mojave
    sha256 "91fb1d17a1c85440a20371dab0106439573d441e4f3168b515707b5863a7ed88" => :high_sierra
  end

  depends_on "sbt" => :build
  depends_on java: "1.8"

  def install
    system "./sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar",
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
