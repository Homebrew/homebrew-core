class Unitycatalog < Formula
  desc "Open, Multi-modal Catalog for Data & AI"
  homepage "https://unitycatalog.io/"
  url "https://github.com/unitycatalog/unitycatalog/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d6ea45b16cd8747cdc1179c3fd07c85706e2f2d17bae87fd90041e8d22b794f5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7669ac406d079ff4c7360867e0c784c6ac6dc51dc1cc2a6e1658d029b98519a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7669ac406d079ff4c7360867e0c784c6ac6dc51dc1cc2a6e1658d029b98519a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7669ac406d079ff4c7360867e0c784c6ac6dc51dc1cc2a6e1658d029b98519a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d725022612d13367871c93c6fe214130739e311d835e89bd97b7d4afccd34e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0146047d203688a4708d36c4648e02db373387d170cc0732b5026ef61909e18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a87dcd9dded878c524abcfdfedf51bedf414a6e744b3910911f065e6aaf5dc"
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
