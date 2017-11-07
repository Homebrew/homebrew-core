class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs' successor)"
  homepage "https://spotbugs.github.io/"
  url "http://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/3.1.0/spotbugs-3.1.0.tgz"
  sha256 "c1eab4dc50cd9854c83fc4a90b4a9b9c63e5307bd0f0f7bb04720e17153b629c"
  head "https://github.com/spotbugs/spotbugs.git"

  bottle :unneeded

  depends_on "gradle" => :build
  depends_on :java => "1.8+"

  def install
    if build.head?
      system "gradle", "build"
      system "gradle", "installDist"
      libexec.install Dir["spotbugs/build/install/spotbugs/*"]
    else
      libexec.install Dir["*"]
    end
    bin.install_symlink "#{libexec}/bin/spotbugs"
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
    system "javac", "HelloWorld.java"
    system "jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    assert_match /M V EI.*\nM C UwF.*\n/, shell_output("#{bin}/spotbugs -textui HelloWorld.jar")
  end
end
