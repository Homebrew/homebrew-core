class Unitycatalog < Formula
  desc "Open, Multi-modal Catalog for Data & AI"
  homepage "https://unitycatalog.io/"
  url "https://github.com/unitycatalog/unitycatalog/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "176961234b38ec784660c2804ccb59df79feec1fb1dd5829b6f97e8ba3412605"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee881ebb4140d889e7f410720bc914ba18103102b30be7e63cebd06ef69f5629"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee881ebb4140d889e7f410720bc914ba18103102b30be7e63cebd06ef69f5629"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee881ebb4140d889e7f410720bc914ba18103102b30be7e63cebd06ef69f5629"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee881ebb4140d889e7f410720bc914ba18103102b30be7e63cebd06ef69f5629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32924b5b58778dcdfd46578afbb6304c0ded6ab5d720549cde3fed78fa3070b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32924b5b58778dcdfd46578afbb6304c0ded6ab5d720549cde3fed78fa3070b5"
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
