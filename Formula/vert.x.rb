class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/4.1.5/vertx-stack-manager-4.1.5-full.tar.gz"
  sha256 "67b4d6d55ffafae0e499883593b93ac132f6b199fe7c694dc177e81954689cf8"
  license any_of: ["EPL-2.0", "Apache-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90aa408565fe31888233081e492d64dcc3add72493ad617a1edb1017c58358da"
    sha256 cellar: :any_skip_relocation, big_sur:       "90aa408565fe31888233081e492d64dcc3add72493ad617a1edb1017c58358da"
    sha256 cellar: :any_skip_relocation, catalina:      "90aa408565fe31888233081e492d64dcc3add72493ad617a1edb1017c58358da"
    sha256 cellar: :any_skip_relocation, mojave:        "90aa408565fe31888233081e492d64dcc3add72493ad617a1edb1017c58358da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ec032fe17834c3e9235a84ed24557409c7517b0461ab44ce97d5d4297b499ad"
    sha256 cellar: :any_skip_relocation, all:           "5cc770ceb48f5a39fae9abb3677c48fb3c6250b3c55af486d45c08117997a449"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
    (bin/"vertx").write_env_script "#{libexec}/bin/vertx", Language::Java.overridable_java_home_env
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
