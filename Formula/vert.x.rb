class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM."
  homepage "http://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.3.2-full.tar.gz"
  sha256 "49479e82cd5444c693f24a4fb8bad1694f77a3137dc1c66d6dc1ffec0ecc3ac0"

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
