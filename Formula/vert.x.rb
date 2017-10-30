class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "http://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.5.0-full.tar.gz"
  sha256 "aa4607b5191f6df369d9b765fbc58ecc8ec9a1075fc45d1326ae7812fd85970b"

  bottle :unneeded
  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
    bin.install_symlink "#{libexec}/bin/vertx"
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
