class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.1.1.tar.gz"
  sha256 "4c789ee33ecff2b655bc839c5ebc7b20d581f99529f8f553628ed38d9615e553"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbe88a3f9c8cc5637d32f93942f0fe0b9298fe5d55f1c8dedbbfa41663c837fd" => :sierra
    sha256 "ba0d1e153439c8a6d2ab7037724e62690677b830ec557590416e692ea9f77fe8" => :el_capitan
    sha256 "11a606626ee084f75991adf09eedc6e08a702991becd5df4c83b41b83d6487cf" => :yosemite
  end

  depends_on "sbt" => :build
  depends_on :java => "1.6+"

  def install
    # Prevents sandbox violation
    ENV.java_cache
    system "./sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar",
                    "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
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
