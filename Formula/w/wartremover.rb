class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/refs/tags/v3.5.6.tar.gz"
  sha256 "b40f76f3a14642f483c6be4ba1ed54882d1364a65481f4f892eb7900fd9c7d67"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb0a908967673f88014a197ffe0befe02a4e1d4072e77d0d00284d69a42e5b9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb0a908967673f88014a197ffe0befe02a4e1d4072e77d0d00284d69a42e5b9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb0a908967673f88014a197ffe0befe02a4e1d4072e77d0d00284d69a42e5b9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb0a908967673f88014a197ffe0befe02a4e1d4072e77d0d00284d69a42e5b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0c1b467990b722c863de9af5db7993e17daa477ee8675aa38be89bc19f1a3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0c1b467990b722c863de9af5db7993e17daa477ee8675aa38be89bc19f1a3a6"
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
