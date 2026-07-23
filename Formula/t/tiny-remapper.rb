class TinyRemapper < Formula
  desc "Tiny, efficient tool for remapping JAR files using \"Tiny\"-format mappings"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/0.14.0/tiny-remapper-0.14.0-fat.jar"
  sha256 "9dbaf8030981338373abe029cd9c07732bff437887a56de1735ba2c3c76b0acf"
  license "LGPL-3.0-only"

  livecheck do
    url "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad03f9960d6d25762e84e6de5633a06828b3592b3779d8b06d0dd3374fd84270"
  end

  depends_on "openjdk"

  def openjdk
    Formula["openjdk"]
  end

  def install
    libexec.install "tiny-remapper-#{version}-fat.jar"
    bin.write_jar_script libexec/"tiny-remapper-#{version}-fat.jar", "tiny-remapper"
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
