class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/4.1.4/vertx-stack-manager-4.1.4-full.tar.gz"
  sha256 "bd8fe99274e8f910810e49e3bd873cc84097e784de9eeb310907755c166a568a"
  license any_of: ["EPL-2.0", "Apache-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1915cef1b2d7af77c9dd20f1009eace2af71e3881c53a0c151561542062cb4c"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
    (bin/"vertx").write_env_script "#{libexec}/bin/vertx", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      import io.vertx.core.AbstractVerticle;
      public class HelloWorld extends AbstractVerticle {
        public void start() {
          System.out.println("Hello World!");
          vertx.close();
          System.exit(0);
        }
      }
    EOS
    output = shell_output("#{bin}/vertx run HelloWorld.java")
    assert_equal "Hello World!\n", output
  end
end
