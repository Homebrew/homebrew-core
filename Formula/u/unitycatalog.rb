class Unitycatalog < Formula
  desc "Open, Multi-modal Catalog for Data & AI"
  homepage "https://unitycatalog.io/"
  url "https://github.com/unitycatalog/unitycatalog/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "fc23df4b6617a1cf1f53e822b68b68490f5272912753b5a6fb76c1734d461800"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f0655ffb8055a1f5c471d3fbf7a51103cf13f9ea559f86bc47acbff0847a9b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f0655ffb8055a1f5c471d3fbf7a51103cf13f9ea559f86bc47acbff0847a9b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f0655ffb8055a1f5c471d3fbf7a51103cf13f9ea559f86bc47acbff0847a9b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09f84bb4180c1098963a3ecd203a39610ef24e9988f47dedb6545ef8be894015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6713eeb72009563fc80f536032577413ee0298d9d27cd3c145a3ea13da50d0a4"
  end

  depends_on "sbt" => :build
  depends_on "openjdk@21"

  # SBT resolves dependencies during the build; the test starts a local server.
  allow_network_access! [:build, :test]

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
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
    require "socket"

    # The server binds the requested port and the following port.
    port = loop do
      candidate = free_port
      next if candidate == 65535

      begin
        TCPServer.new(candidate + 1).close
        break candidate
      rescue Errno::EADDRINUSE
        next
      end
    end
    pid = spawn formula_opt_bin("openjdk@21")/"java",
                "-cp", (libexec/"jars/classpath").read.strip,
                "io.unitycatalog.server.UnityCatalogServer", "--port", port.to_s
    sleep 20

    output = shell_output("#{bin}/uc catalog list --server http://localhost:#{port}")
    assert_match "[]", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
