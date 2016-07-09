class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM."
  homepage "http://vertx.io/"
  url "https://dl.bintray.com/vertx/downloads/vert.x-3.3.1-full.tar.gz"
  sha256 "d37b5e4bfd8c1cbfb90c0e86369968de2d61cf6c5ebd3d9aa435e5fadf5967c7"

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
