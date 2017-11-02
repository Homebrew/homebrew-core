class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs' successor)"
  homepage "https://spotbugs.github.io/"
  url "https://github.com/spotbugs/spotbugs/archive/3.1.0.tar.gz"
  sha256 "ac6169a551212756a05dd9c066ef9212653d8a99b754ef4dade6a7008f8ad781"
  head "https://github.com/spotbugs/spotbugs.git"

  depends_on "gradle" => :build
  depends_on :java => "1.8+"

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install Dir["spotbugs/build/install/spotbugs/*"]
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
    system "jar", "cvfe", "HelloWorld.jar", "HelloWorld", "*.class"
    assert_match /M V EI.*\nM C UwF.*\n/, shell_output("#{bin}/spotbugs", "-textui", "HelloWorld.jar")
  end
end
