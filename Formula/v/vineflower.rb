class Vineflower < Formula
  desc "Java decompiler"
  homepage "https://vineflower.org/"
  url "https://github.com/Vineflower/vineflower/archive/refs/tags/1.12.0.tar.gz"
  sha256 "25c783b5b73fd0ae8c904c9ea3e7ee1e6713812d4d5fd085547fb20f1dacfdfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91e7c7ca9e70c60bb7b16aab8fe65a2af39059f5dc2dd1d37a0e4fa0e1cc20da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2994bdcc86051fe14ca1cbbfa81a7af61ee3d80b44d24d58a78cd9f6b26dc24c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b0f0adaa1789a67e178d4461bb74014c21d288126d2500b420ad5cd479b785"
    sha256 cellar: :any_skip_relocation, sonoma:        "b44b38172f537e0270cc5a595daf74618b5a6628c91bd0024c804fb12e664951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac798f1f14c0f517d1a6a4c62de6b0d7a48d154a628e353825e44c178a113b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e4e4f0c65df994935ac48a57c5a367dd05eea111bf6f75e1e74dc2029e51016"
  end

  # Issue ref: https://github.com/Vineflower/vineflower/issues/495
  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build", "-x", "test"

    version_suffix = ENV["GITHUB_ACTIONS"] ? "" : "+local"
    jar = Dir["build/libs/vineflower-#{version}#{version_suffix}.jar"].first
    libexec.install jar => "vineflower.jar"

    bin.write_jar_script libexec/"vineflower.jar", "vineflower"
  end

  test do
    (testpath/"FooBar.java").write <<~JAVA
      public class FooBar {
        public static void bar() {}
        public static void foo() {
          bar();
        }
      }
    JAVA

    system Formula["openjdk"].bin/"javac", "FooBar.java"
    refute_includes shell_output("#{bin}/vineflower FooBar.class"), "error"
  end
end
