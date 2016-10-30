class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v1.1.1.tar.gz"
  sha256 "fe6ae5cc1e721f5757664d85d6b580aded1209186839055ecf709ba1be2d812b"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea22c6b58274f774cf4f45f71fa8b635b08681198aeedb62b7c3fc2b792c1ee6" => :sierra
    sha256 "33e94b3ddcee3d253eed828e19dca77f75e5f6d128cdd3a713ed5ee495421fde" => :el_capitan
    sha256 "54890a9dbf80473bd017271908918dc162b55cd67f301a930fd1c70ccec75f20" => :yosemite
    sha256 "ab00ec5f2085b316009f92d3fbda0d763d5c9edf75fac6152362a39f08186247" => :mavericks
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
