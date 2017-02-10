class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v1.3.0.tar.gz"
  sha256 "2b0b80daf7e461e5cd249cc8059ef9de5a91a10aec8f01e8f3e196983ad08a2a"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56c2858bd72b7997219f6034534e7b0cb97da10939e26936c462bcc02bd0b726" => :sierra
    sha256 "9e4688767bdf6178528ee96e52d53f7d019f475a17c101865a6970e7afa335b5" => :el_capitan
    sha256 "a76c23da958f22a8157206873d06b35ca54aba785e432ca01214af9647237437" => :yosemite
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
