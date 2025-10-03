class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "196ae02ea2717e56f848ad055996373d7b402c3cf930f24f449073964a4abdd4"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f926d544a948151379125fe3ff4b4da1536d4cf337b3d9c2884f61fbc4284374"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  # Fix to error: Deduplicate found
  # PR ref: https://github.com/wartremover/wartremover/pull/1418
  patch do
    url "https://github.com/wartremover/wartremover/commit/8dd18c1c3999dbabded920709a8c7c07e2e3b8c1.patch?full_index=1"
    sha256 "cee269e254b64deef154ba13d58f68a2cabbfec41c6e659676afc21e25ca714a"
  end

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
