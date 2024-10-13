class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https://spotbugs.github.io/"
  url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/4.8.6/spotbugs-4.8.6.tgz"
  sha256 "b9d4d25e53cd4202b2dc19c549c0ff54f8a72fc76a71a8c40dee94422c67ebea"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e44f0519c568b957cb32657ba6eca41c393e7983d0f61caf94eeaa03f00c6e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27e6002a2ee2a2c2664291af654541a77bb6a925e66393eb783423f072a1c830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27e6002a2ee2a2c2664291af654541a77bb6a925e66393eb783423f072a1c830"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27e6002a2ee2a2c2664291af654541a77bb6a925e66393eb783423f072a1c830"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a7b66466aff1f1bc50ecc52faa62044a42e736a09c5d9d296d0b8ee6605cead"
    sha256 cellar: :any_skip_relocation, ventura:        "9a7b66466aff1f1bc50ecc52faa62044a42e736a09c5d9d296d0b8ee6605cead"
    sha256 cellar: :any_skip_relocation, monterey:       "27e6002a2ee2a2c2664291af654541a77bb6a925e66393eb783423f072a1c830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83822f6a3a9e21032c8d4a4283161c6a8f8566828c7a14519d54bb39f90a7b18"
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
