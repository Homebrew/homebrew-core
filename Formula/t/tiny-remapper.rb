class TinyRemapper < Formula
  desc "Tiny, efficient tool for remapping JAR files using \"Tiny\"-format mappings"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/0.15.0/tiny-remapper-0.15.0-fat.jar"
  sha256 "ca93f562ab05daea928c7b89a355188c068d6154c9f7f485e8704dbaf35bfd44"
  license "LGPL-3.0-only"

  livecheck do
    url "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8137195f809c8c06fdb9e70153728cebaf0755f4cc426ecfadbd10812531f4cc"
  end

  # TODO: Switch back to `openjdk` once a release bundles an ASM that supports
  # class file major version 71 (JDK 27); 0.14.1 fails with
  # "Unsupported class file major version 71".
  depends_on "openjdk@25"

  def openjdk
    Formula["openjdk@25"]
  end

  def install
    libexec.install "tiny-remapper-#{version}-fat.jar"
    bin.write_jar_script libexec/"tiny-remapper-#{version}-fat.jar", "tiny-remapper",
                         java_version: "25"
  end

  test do
    (testpath/"Main.java").write <<~JAVA
      import java.lang.reflect.Method;

      class Main {
        private static void method_1234() {
          Method[] methods = Main.class.getDeclaredMethods();

          for (Method method : methods) {
            System.out.println("method " + method.getName());
          }
        }

        public static void main(String args[]) {
          method_1234();
        }
      }
    JAVA

    (testpath/"mappings.tiny").write <<~TINY
      tiny	2	0	intermediary	named
      c	Main	Main
      \tm	()V	method_1234	printMethods
    TINY

    javac = openjdk.opt_bin/"javac"
    java = openjdk.opt_bin/"java"
    jar = openjdk.opt_bin/"jar"

    system javac, "Main.java"
    system jar, "-cf", "input.jar", "Main.class"
    assert_match "method method_1234", shell_output("#{java} -cp input.jar Main")

    system bin/"tiny-remapper", "input.jar", "output.jar", "mappings.tiny", "intermediary", "named"
    assert_match "method printMethods", shell_output("#{java} -cp output.jar Main")
  end
end
