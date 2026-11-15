class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://www.wartremover.org/"
  url "https://github.com/wartremover/wartremover/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "5e59bdf52b921ff0292d11ef41518046729a491f4b515510ff0d70562a75ab20"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98c429ae80b3516e29dfed49932e8496088559ac554896f44982bf3ebf95e186"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98c429ae80b3516e29dfed49932e8496088559ac554896f44982bf3ebf95e186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98c429ae80b3516e29dfed49932e8496088559ac554896f44982bf3ebf95e186"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99ca5ada0097b2a5908b991d63fd06c322f17d9c7ebd431e871a24c261040aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "99ca5ada0097b2a5908b991d63fd06c322f17d9c7ebd431e871a24c261040aec"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "--server", "assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
  end

  test do
    (testpath/"foo").write <<~SCALA
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    SCALA
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end
