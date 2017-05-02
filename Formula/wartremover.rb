class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v2.0.3.tar.gz"
  sha256 "223af24da9ccf33860ca919ad2742b0de3d604625cc4aad8f97314f8c49db242"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "abb812f705073a406dff4becf55f200abc5c69cd43a026cca2b0ddc3ae9d7e73" => :sierra
    sha256 "0a7fa44e79932521b3945e293e49e755a37c88ed9e238e37e878f8e314d1a8c8" => :el_capitan
    sha256 "9779d1d9528db6cc3d7d2a06589aa846021dd5d33d48dff1179f788d2e7bb57c" => :yosemite
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
