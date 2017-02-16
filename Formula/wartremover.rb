class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v2.0.2.tar.gz"
  sha256 "575a73c53cf2a40aa395fad3366f927225b85cc94301b67b2f2f79eed16b0eee"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4f7d332950d7253b5c5e1074569e8969656a237cee94cd2c5abaee6aec96a52" => :sierra
    sha256 "4f5ae008a65e0563e51b2d89b715d87122f2887dc5a88bfef3f5a2c48b842342" => :el_capitan
    sha256 "ac3c5ac731a5078463a7846c74c82137d4d6c93bd3f84eeb08b577fc6c6a37e5" => :yosemite
  end

  depends_on "sbt" => :build

  def install
    # Prevents sandbox violation
    ENV.java_cache
    system "sbt", "core/assembly"
    libexec.install Dir["core/target/scala-*/wartremover-assembly-*.jar"]
    bin.write_jar_script Dir[libexec/"wartremover-assembly-*.jar"][0], "wartremover"
  end

  test do
    (testpath/"foo").write <<-EOS.undent
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
