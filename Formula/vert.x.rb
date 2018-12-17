class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.6.2-full.tar.gz"
  sha256 "0157c9ee2db462f83dbc1b7f56d89c6b9b88eff58da1d0406b4f38b44c7d3b71"

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
