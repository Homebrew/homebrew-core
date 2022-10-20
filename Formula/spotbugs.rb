class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https://spotbugs.github.io/"
  url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/4.7.3/spotbugs-4.7.3.tgz"
  sha256 "f02e2f1135b23f3edfddb75f64be0491353cfeb567b5a584115aa4fd373d4431"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4a351e6423603de5b05a114912e6091977f287357ea8c23fbba1944026bba72"
  end

  head do
    url "https://github.com/spotbugs/spotbugs.git"

    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  conflicts_with "fb-client", because: "both install a `fb` binary"

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
    system Formula["openjdk"].bin/"javac", "HelloWorld.java"
    system Formula["openjdk"].bin/"jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    output = shell_output("#{bin}/spotbugs -textui HelloWorld.jar")
    assert_match(/M V EI.*\nM C UwF.*\n/, output)
  end
end
