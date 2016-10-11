class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM."
  homepage "http://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.3.3-full.tar.gz"
  sha256 "9f7d374ad10726af12a203aa089e0f4e5cc68d8d1a82bb71f567d9f75005e99a"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
    bin.install_symlink "#{libexec}/bin/vertx"
  end

  test do
    (testpath/"HelloWorld.java").write <<-EOS.undent
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
