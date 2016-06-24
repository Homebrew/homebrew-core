class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM."
  homepage "http://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.3.0-full.tar.gz"
  sha256 "413eab37a8b6bc1e14afb105528d81b3287a459905f10aeba865a0fa5d41cf9c"

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
    system "#{bin}/vertx", "run", "HelloWorld.java"
  end
end
