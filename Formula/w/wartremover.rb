class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://www.wartremover.org/"
  url "https://github.com/wartremover/wartremover/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "311ae54c70e846c43137fa5ed63f142f6eb45e92f684615033ed2645ad32b353"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f211cb144d0bc21d9dbbacb0fab92236267ce03b295c8acf8e692a51d55c91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f211cb144d0bc21d9dbbacb0fab92236267ce03b295c8acf8e692a51d55c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f211cb144d0bc21d9dbbacb0fab92236267ce03b295c8acf8e692a51d55c91"
    sha256 cellar: :any_skip_relocation, sonoma:        "40f211cb144d0bc21d9dbbacb0fab92236267ce03b295c8acf8e692a51d55c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91d94a4f3ec102d5c764d9afa099c6dd17585a2abda47f29b72463aff858791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91d94a4f3ec102d5c764d9afa099c6dd17585a2abda47f29b72463aff858791"
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
