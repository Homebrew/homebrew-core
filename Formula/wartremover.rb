class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v1.3.0.tar.gz"
  sha256 "2b0b80daf7e461e5cd249cc8059ef9de5a91a10aec8f01e8f3e196983ad08a2a"
  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64798b426d40127d83d3df9e83730b4a41d4cc338d0aaf95e652de37e638effa" => :sierra
    sha256 "84c331ce91633ddb1f30908eed602be7f63198f9b7728ebf635fdfe16eb7f509" => :el_capitan
    sha256 "00555d0786a51bb93fe8ee7ea2fb1893be7cd0df36af6237608930a06074a5d6" => :yosemite
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
