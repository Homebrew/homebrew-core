class TinyRemapper < Formula
  desc "Tiny, efficient tool for remapping JAR files using \"Tiny\"-format mappings"
  homepage "https://fabricmc.net/"
  # TODO: Check if we can use `openjdk` 25+ when bumping the version.
  url "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/0.12.3/tiny-remapper-0.12.3-fat.jar"
  sha256 "703a3d340f4e06e850efbfd05ce4fbee3e367c4a59d48486504f7341410f4be5"
  license "LGPL-3.0-only"

  livecheck do
    url "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e0ecbc5570666c0f10eb90e91071bd2ca712521e4fede1ac13c264a3dcf9402"
  end

  depends_on "openjdk@21"

  def openjdk
    Formula["openjdk@21"]
  end

  def install
    libexec.install "tiny-remapper-#{version}-fat.jar"
    bin.write_jar_script libexec/"tiny-remapper-#{version}-fat.jar", "tiny-remapper",
                         java_version: "21"
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
