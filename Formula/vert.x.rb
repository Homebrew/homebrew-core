class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://bintray.com/vertx/downloads/download_file?file_path=vert.x-3.8.0-full.tar.gz"
  sha256 "660dc32533eb3d37771be2f70497b2346a5d174abb782c17f334cbc36adcdcc9"

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
