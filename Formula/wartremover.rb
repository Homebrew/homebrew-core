class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v1.0.0.tar.gz"
  sha256 "b315b38ccb633c14c83ea699cb8d12fa8a7105e3c6b066b87c1b53e9eb95a043"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11b231be52c5e33487d2a68c51dd2dec57e4f6d5ae0e5ea579813668b4ddc504" => :el_capitan
    sha256 "153ba2e298749b87d75bdb04da31a63a0a453fcf1371525c6a3c9bae351e8fcb" => :yosemite
    sha256 "dbb57e97b6672ef9fde16f61db87ed5c1568e629fa1c7672b17425ef267f23a5" => :mavericks
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
