class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.8.4-full.tar.gz"
  sha256 "96e7d10763216796aa7d8f324822f4e6a4a9dff84758052c7719d7035e8ae14c"

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
