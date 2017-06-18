class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.1.1.tar.gz"
  sha256 "4c789ee33ecff2b655bc839c5ebc7b20d581f99529f8f553628ed38d9615e553"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38422af4a85e008b1405bac3aba599e5465b1ce5990ebd482132d460eb31ba49" => :sierra
    sha256 "2a91c4fb3c3f070a2828875eacc72c73d36928bea0b9169769435ed66538d9ff" => :el_capitan
    sha256 "a39d5db621275982f364f37a5e6d2c0ccd3a507c1c9afa8a6693123b75d4413c" => :yosemite
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
