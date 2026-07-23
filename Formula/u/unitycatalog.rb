class Unitycatalog < Formula
  desc "Open, Multi-modal Catalog for Data & AI"
  homepage "https://unitycatalog.io/"
  url "https://github.com/unitycatalog/unitycatalog/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "3626e1ae4e658cd297b044ad2d9602d10c5e6eda0fe706ef1a7369c49e1bbce2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fc4ad3373fd679bf4d6373968c716194753700c185afc7b24c5a9adf029e295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc4ad3373fd679bf4d6373968c716194753700c185afc7b24c5a9adf029e295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc4ad3373fd679bf4d6373968c716194753700c185afc7b24c5a9adf029e295"
    sha256 cellar: :any_skip_relocation, sonoma:        "84d326883b4f6d232ca60b8bbfdb9a8b959e773c00cb8e54b5b579fe4dbdde92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00db5bde8143cc11e7ea4acaf643e922e5863a3ee4354450ac22511375b7c63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f498695d5054dff58b8dde0f6a68255551254c4cbdd25461f75d748196bb0f"
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
