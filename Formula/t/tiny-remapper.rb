class TinyRemapper < Formula
  desc "Tiny, efficient tool for remapping JAR files using \"Tiny\"-format mappings"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/0.11.2/tiny-remapper-0.11.2-fat.jar"
  sha256 "0376b17b92f858956e018da672affb5485c18085db681f9547664996e82b6688"
  license "LGPL-3.0-only"

  livecheck do
    url "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99a430d8364a495aab6a8d0567737652cc7cd9e64606cb76ba10120eef0c8926"
  end

  depends_on "openjdk"

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

    system Formula["openjdk"].bin/"javac", "Main.java"
    system Formula["openjdk"].bin/"jar", "-cf", "input.jar", "Main.class"
    assert_match "method method_1234", shell_output("#{Formula["openjdk"].bin}/java -cp input.jar Main")

    system bin/"tiny-remapper", "input.jar", "output.jar", "mappings.tiny", "intermediary", "named"
    assert_match "method printMethods", shell_output("#{Formula["openjdk"].bin}/java -cp output.jar Main")
  end
end
