class Vineflower < Formula
  desc "Java decompiler"
  homepage "https://vineflower.org/"
  url "https://github.com/Vineflower/vineflower/archive/refs/tags/1.11.1.tar.gz"
  sha256 "104df4042023190416bff2ad0e2386ddf7669c6aa585f19b9d965a7f5ca5132b"
  license "Apache-2.0"

  depends_on "gradle" => :build
  depends_on "openjdk@21"

  def install
    system "gradle", "build", "-x", "test"

    version_suffix = ENV["GITHUB_ACTIONS"] ? "" : "+local"
    jar = Dir["build/libs/vineflower-#{version}#{version_suffix}.jar"].first
    libexec.install jar => "vineflower.jar"

    bin.write_jar_script libexec/"vineflower.jar", "vineflower", java_version: "21"
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
    system Language::Java.java_home("21")/"bin"/"javac", "FooBar.java"
    refute_includes shell_output("#{bin}/vineflower FooBar.class"), "error"
  end
end
