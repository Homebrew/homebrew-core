class Unitycatalog < Formula
  desc "Open, Multi-modal Catalog for Data & AI"
  homepage "https://unitycatalog.io/"
  url "https://github.com/unitycatalog/unitycatalog/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fae708a22f1e38e19f754aca22925d66016a7efeaab680ce87c27496c75078d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8d0ef55f20e1d003a29001a2e018e6b0fb839a6c0bab924c25815a92ec7ed421"
  end

  depends_on "sbt" => :build
  depends_on "openjdk@21"

  def install
    system "sbt", "createTarball"

    mkdir "build" do
      system "tar", "xzf", "../target/unitycatalog-#{version}.tar.gz", "-C", "."

      inreplace "jars/classpath" do |s|
        s.gsub! %r{[^:]+/([^/]+\.jar)}, "#{libexec}/jars/\\1"
      end

      prefix.install "bin"
      libexec.install "jars"
      pkgetc.install "etc"
    end

    java_env = Language::Java.overridable_java_home_env("21")
    java_env["PATH"] = "${JAVA_HOME}/bin:${PATH}"
    bin.env_script_all_files libexec/"bin", java_env
  end

  service do
    run opt_bin/"start-uc-server"
    working_dir etc/"unitycatalog"
  end

  test do
    port = free_port
    spawn bin/"start-uc-server", "--port", port.to_s
    sleep 20

    output = shell_output("#{bin}/uc catalog list --server http://localhost:#{port}")
    assert_match "[]", output
  end
end
