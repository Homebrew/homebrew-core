class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v2.0.0.tar.gz"
  sha256 "c4d1a72dcf0db3c5029e2bf4d8c17d9acb131a4f4c1b60a49117e74679f1407c"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d9292bbfcd9905ae5010709120c8311e602c7693f46ccafd72b6a9e4435388c" => :sierra
    sha256 "6c9fbe5b7304ed3fa8768d565e96c1f70b626fa0a1a23b5e5da1d893e75dd823" => :el_capitan
    sha256 "dbf650dbf86a7eda18c96911a0e10ff056aaed0864f03abd2584479de0ee0d01" => :yosemite
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
