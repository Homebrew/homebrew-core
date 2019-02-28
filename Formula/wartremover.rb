class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.3.7.tar.gz"
  sha256 "7a418ec9cd5fddb8499b6e1551071be0553cd66c63378107e3e561c47ce421ca"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7be61c2a96a178c4cdafc761bd72e04a24d5e12c1dc4ad6d5b8432c23de751f9" => :mojave
    sha256 "dfa2c1fc983b25b25dac84a17bc0616ed830f2e90dd103f07c4256c9e088ea9a" => :high_sierra
    sha256 "69bae9cedcd33931a7eeb9154069550930f9d25546f9e6be9e69a6ee68163d31" => :sierra
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
