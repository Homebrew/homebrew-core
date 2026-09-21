class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://www.wartremover.org/"
  url "https://github.com/wartremover/wartremover/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "b734a060e2566d5f15386b50ba6b0cca7bf785666d7b4abf47a67698ede40da7"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfd76d0a92310e33268191f6541634a1c0e51e54fef3ae545cd656ba9bff61be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cfd76d0a92310e33268191f6541634a1c0e51e54fef3ae545cd656ba9bff61be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfd76d0a92310e33268191f6541634a1c0e51e54fef3ae545cd656ba9bff61be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4c607456089c14fae5c31082406192e08fc05ba3a3f4eacac82753205f826b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f4c607456089c14fae5c31082406192e08fc05ba3a3f4eacac82753205f826b8"
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
