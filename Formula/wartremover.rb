class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.1.tar.gz"
  sha256 "835e94a3fd6fb570b466d0ae5e596b6f44016f30afdb67deb92645bff65793c1"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01e85d77996388ee65bedaabc6491dc1ca975253d6094e0bd623e0d64cd7cbbe" => :mojave
    sha256 "1fad7adb20404dce7850843855eabf22201b2529074eba5172b37fc9ae300c43" => :high_sierra
    sha256 "2c7330212e207830765c9d2ce10cfb7296e4370af13ed3fe649591412590ddc4" => :sierra
  end

  depends_on "sbt" => :build
  depends_on :java => "1.8"

  def install
    system "./sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar",
                    "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover", :java_version => "1.8"
  end

  test do
    (testpath/"foo").write <<~EOS
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
