class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.4.12.tar.gz"
  sha256 "96aefb990757e1bb8e0bb1202e5abaf2831c671c61b0c567eed63871fb3d04c1"
  license "Apache-2.0"
  revision 1
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26d7317ee347ce31083a93e8e5cce25f92181ababb8cfac46929765afee5497d" => :catalina
    sha256 "affcd0b426e565cb6bb3410f89586eb9675820b60a8d0ca680dc7b0c6d1ef3d1" => :mojave
    sha256 "13a05da126316b1e546e0f66162ddd411f449f100fc98b59ce1344406e3ef440" => :high_sierra
  end

  depends_on "sbt" => :build
  depends_on "openjdk@8"

  def install
    system "sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar",
                    "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover", java_version: "1.8"
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
