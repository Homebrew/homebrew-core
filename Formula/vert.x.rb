class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://bintray.com/vertx/downloads/download_file?file_path=vert.x-3.9.1-full.tar.gz"
  sha256 "f0671566e3dc505282deee0aca2141583e45bd577e4d55ac7e961ad041be6472"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
    (bin/"vertx").write_env_script "#{libexec}/bin/vertx",
      :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
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
