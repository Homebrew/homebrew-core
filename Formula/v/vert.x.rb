class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/4.1.5/vertx-stack-manager-4.1.5-full.tar.gz"
  sha256 "67b4d6d55ffafae0e499883593b93ac132f6b199fe7c694dc177e81954689cf8"
  license any_of: ["EPL-2.0", "Apache-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "45b95b3679a4ec881e78b5e4a7bc1307273f7897aea04fad0684be910b233d17"
  end

  # Upstream cannot write a test that works on formula
  # Issue ref: https://github.com/vertx-distrib/homebrew-tap/issues/4
  disable! date: "2024-01-12", because: "cannot test"

  # Unrecognized VM option 'UseBiasedLocking' since JDK 19
  depends_on "openjdk@17"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin conf lib]
    (bin/"vertx").write_env_script libexec/"bin/vertx", Language::Java.overridable_java_home_env("17")
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
