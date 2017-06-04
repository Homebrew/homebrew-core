class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v2.1.0.tar.gz"
  sha256 "a2d200d40ac9c5b7a2d31e934547035d929c0640f7d441c84c77cf8f6e52dea6"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbe88a3f9c8cc5637d32f93942f0fe0b9298fe5d55f1c8dedbbfa41663c837fd" => :sierra
    sha256 "ba0d1e153439c8a6d2ab7037724e62690677b830ec557590416e692ea9f77fe8" => :el_capitan
    sha256 "11a606626ee084f75991adf09eedc6e08a702991becd5df4c83b41b83d6487cf" => :yosemite
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
