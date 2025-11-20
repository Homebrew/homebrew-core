class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https://spotbugs.github.io/"
  url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/4.9.8/spotbugs-4.9.8.tgz"
  sha256 "2eb8e0f2b223c22ffa2ce0c1cf1be4127dde19d240b8f7ce69a5fd3ad5c36ff3"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34e866a9f0f8cdad01631157a6c33ec24dcc14b8cf4dc046dac6a41acf697c8d"
  end

  head do
    url "https://github.com/spotbugs/spotbugs.git", branch: "master"

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
    (testpath/"HelloWorld.java").write <<~JAVA
      public class HelloWorld {
        private double[] myList;
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
        public double[] getList() {
          return myList;
        }
      }
    JAVA
    system Formula["openjdk"].bin/"javac", "HelloWorld.java"
    system Formula["openjdk"].bin/"jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    output = shell_output("#{bin}/spotbugs -textui HelloWorld.jar")
    assert_match(/M V EI.*\nM C UwF.*\n/, output)
  end
end
