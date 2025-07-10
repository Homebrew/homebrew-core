class Unitycatalog < Formula
  desc "Open, Multi-modal Catalog for Data & AI"
  homepage "https://unitycatalog.io/"
  url "https://github.com/unitycatalog/unitycatalog/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fae708a22f1e38e19f754aca22925d66016a7efeaab680ce87c27496c75078d1"
  license "Apache-2.0"

  depends_on "sbt" => :build
  depends_on "openjdk@21"

  def install
    system "sbt", "createTarball"

    mkdir "build" do
      system "tar", "xzf", "../target/unitycatalog-#{version}.tar.gz", "-C", "."

      inreplace "jars/classpath" do |s|
        s.gsub! %r{[^:]+/([^/]+\.jar)}, "#{libexec}/jars/\\1"
      end

      bin.install Dir["bin/*"]
      libexec.install "jars"
      (etc/"unitycatalog").install "etc"
    end

    env = Language::Java.overridable_java_home_env("21")
    env["PATH"] = "${JAVA_HOME}/bin:${PATH}" if OS.linux?
    bin.env_script_all_files libexec/"bin", env
  end

  service do
    run opt_bin/"start-uc-server"
    working_dir etc/"unitycatalog"
  end

  test do
    port = free_port
    spawn bin/"start-uc-server", "--port", port.to_s
    sleep 15

    output = shell_output("#{bin}/uc catalog list --server http://localhost:#{port}")
    assert_match "[]", output
  end
end
