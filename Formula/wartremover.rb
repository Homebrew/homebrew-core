class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v1.0.1.tar.gz"
  sha256 "cf3f2a41195e869971b0717447ac514fbaba68bcd28cc08055ad0b08c5c27f10"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "606d8cae5fdc5bf67c1610898eb93abd4fea05d1a0a3b19b5844af0be1ab9d60" => :el_capitan
    sha256 "5f60170aa9cc8fa18d3cc91c7ca0a3a32f0529842d2d27ce7cc347a1c9b3afe1" => :yosemite
    sha256 "a1057ac0a84fcea8ab7b62b7dd1f523a45fa68f9de3fbe53ac095583330d1650" => :mavericks
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
