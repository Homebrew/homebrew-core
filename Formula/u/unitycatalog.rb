class Unitycatalog < Formula
  desc "Open, Multi-modal Catalog for Data & AI"
  homepage "https://unitycatalog.io/"
  url "https://github.com/unitycatalog/unitycatalog/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c1a66bac444ce23a472141f1d3c16f2ea7022d93d9537837315cfa71639faa0a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f46a0ad62350e1623ffc4c18b7fc4dc424037f418db390fc4da48f5d71cfc8c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46a0ad62350e1623ffc4c18b7fc4dc424037f418db390fc4da48f5d71cfc8c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f46a0ad62350e1623ffc4c18b7fc4dc424037f418db390fc4da48f5d71cfc8c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "073bc389be552f97620a6dd0f9b80f9bfb817c3a9303957441e40682dbad9b49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bee58c27c97bec97ae281b329f8e1d401b24d5e44d49cbffbbc6854f39a7848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b87e02a9d2476cbc9ed5463c80bb666b6e16d3d393302cbbbc9f55ba0c020d94"
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
