class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https://spotbugs.github.io/"
  url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/4.2.0/spotbugs-4.2.0.tgz"
  sha256 "f5e2ad6e94515923a8b9a6db370d3b34a3aad9eda13315146b9bbd03bcbe7e30"
  license "LGPL-2.1-or-later"

  head do
    url "https://github.com/spotbugs/spotbugs.git"

    depends_on "gradle" => :build
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    if build.head?
      system "gradle", "build"
      system "gradle", "installDist"
      libexec.install Dir["spotbugs/build/install/spotbugs/*"]
    else
      libexec.install Dir["*"]
      chmod 0755, "#{libexec}/bin/spotbugs"
    end
    (bin/"spotbugs").write_env_script "#{libexec}/bin/spotbugs", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      public class HelloWorld {
        private double[] myList;
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
        public double[] getList() {
          return myList;
        }
      }
    EOS
    system "#{Formula["openjdk"].bin}/javac", "HelloWorld.java"
    system "#{Formula["openjdk"].bin}/jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    output = shell_output("#{bin}/spotbugs -textui HelloWorld.jar")
    assert_match /M V EI.*\nM C UwF.*\n/, output
  end
end
