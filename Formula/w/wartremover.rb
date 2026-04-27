class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/refs/tags/v3.5.7.tar.gz"
  sha256 "ceda13f07ab4cad37e31dd73c199e803a10ab6e8f9081c3f77a3bf34e1f8f149"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f903986fd06ecfd7f0b564381baf677233c9de93e576eab0083870578e1abd34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f903986fd06ecfd7f0b564381baf677233c9de93e576eab0083870578e1abd34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f903986fd06ecfd7f0b564381baf677233c9de93e576eab0083870578e1abd34"
    sha256 cellar: :any_skip_relocation, sonoma:        "f903986fd06ecfd7f0b564381baf677233c9de93e576eab0083870578e1abd34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32fbe3f1b44707a358770c9293319a643be3002d777413956512ed1ee5ef98ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32fbe3f1b44707a358770c9293319a643be3002d777413956512ed1ee5ef98ab"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
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
