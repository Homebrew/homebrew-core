class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v2.0.3.tar.gz"
  sha256 "223af24da9ccf33860ca919ad2742b0de3d604625cc4aad8f97314f8c49db242"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68c1d18e8dc9fa0458b948a346b2c29e79c5335f03d8af233200794837fe3898" => :sierra
    sha256 "610c613012ba9c04494688bf45a8ca4817b602f3fe3460f4733922c36c640783" => :el_capitan
    sha256 "ab6fece8e11872fc3de9bc5c41380d061192ee8769644f8a453c548dd545f5c2" => :yosemite
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
