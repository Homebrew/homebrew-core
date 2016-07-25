class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v1.1.0.tar.gz"
  sha256 "d97449ad800fe73b8b9c7cb936f8030132324b704dc23a46e1998ecccc96278a"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "70cc9adc1ba9c4f7ca0de76a3bdc3e5be9523e2a87d9f1edae5f97f10f0af0b9" => :el_capitan
    sha256 "479a591c1deb345a9db9599142f8858273459e70f5977a2be96bd6d89ceac772" => :yosemite
    sha256 "17ca35965fb7b6bad0ead13e4eaac6461556bc78d75ce4e32ab6e43be0282e11" => :mavericks
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
