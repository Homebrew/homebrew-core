class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://github.com/trinodb/trino/releases/download/484/trino-server-484.tar.gz"
  sha256 "4b2d05f2e52fcc156b2f137cabc886353e5dde782d12bf71e290ffc13463b81a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98dd750134ab167de0b3b8c8a46d700e90b18834baae19e2f5c823ec2404c924"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98dd750134ab167de0b3b8c8a46d700e90b18834baae19e2f5c823ec2404c924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98dd750134ab167de0b3b8c8a46d700e90b18834baae19e2f5c823ec2404c924"
    sha256 cellar: :any,                 arm64_linux:       "28927a6147f02ca4a96852969da39eba6177c7cfce67ecf25c3f94f710a5bcaf"
    sha256 cellar: :any,                 x86_64_linux:      "1587069d1a878dcc9006827f42045ba3c6af9397a12dff890867869cdfea8fc9"
  end

  depends_on "go" => :build
  # TODO: Try `openjdk` again once the `launcher` resource reaches 321, which adds JDK 27 flags
  depends_on "openjdk@25"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/484.tar.gz"
    sha256 "265ffc9b88c4ca55c9b3704855aa69f5c65522bb51eec36bed8c4aab06d71f38"

    livecheck do
      formula :parent
    end
  end

  resource "trino-cli" do
    url "https://github.com/trinodb/trino/releases/download/484/trino-cli-484"
    sha256 "9a4dc15cf68af58e05165cbf0b5de20fbeb8af0f5280cb43568ac9001aef9b4e"

    livecheck do
      formula :parent
    end
  end

  # `brew livecheck --autobump --resources trino` should show the launcher version which is found by
  # getting airbase version at https://github.com/trinodb/trino/blob/#{version}/pom.xml#L8 and then
  # dep.launcher.version at https://github.com/airlift/airbase/blob/<airbase-version>/airbase/pom.xml#L225
  resource "launcher" do
    url "https://github.com/airlift/launcher/archive/refs/tags/321.tar.gz"
    sha256 "53102119b3aaf09f74c8c1078ed41a0c22742f62dae0fef9d4c1f61231cb8c92"

    livecheck do
      url "https://raw.githubusercontent.com/trinodb/trino/refs/tags/#{LATEST_VERSION}/pom.xml"
      regex(%r{<artifactId>airbase</artifactId>\s*<version>(\d+(?:\.\d+)*)</version>}i)
      strategy :page_match do |page, regex|
        airbase_version = page[regex, 1]
        next if airbase_version.blank?

        get_airbase_page = Homebrew::Livecheck::Strategy.page_content(
          "https://raw.githubusercontent.com/airlift/airbase/refs/tags/#{airbase_version}/airbase/pom.xml",
        )
        next if get_airbase_page[:content].blank?

        get_airbase_page[:content][%r{<dep\.launcher\.version>(\d+(?:\.\d+)*)</dep\.launcher\.version>}i, 1]
      end
    end
  end

  resource "procname" do
    on_linux do
      url "https://github.com/airlift/procname/archive/c75422ec5950861852570a90df56551991399d8c.tar.gz"
      sha256 "95b04f7525f041c1fa651af01dced18c4e9fb68684fb21a298684e56eee53f48"
    end
  end

  def install
    odie "trino-src resource needs to be updated" if version != resource("trino-src").version
    odie "trino-cli resource needs to be updated" if version != resource("trino-cli").version

    # Workaround for https://github.com/airlift/launcher/issues/8
    inreplace "bin/launcher", 'case "$(arch)" in', 'case "$(uname -m)" in' if OS.mac? && Hardware::CPU.intel?

    # Replace pre-build binaries
    rm_r(Dir["bin/{darwin,linux}-*"])
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    platform_dir = buildpath/"bin/#{OS.kernel_name.downcase}-#{arch}"
    resource("launcher").stage do |r|
      ldflags = "-X launcher/args.Version=#{r.version}"
      system "go", "build", "-C", "src/main/go", *std_go_args(ldflags:, output: platform_dir/"launcher")
    end
    if OS.linux?
      resource("procname").stage do
        system "make"
        platform_dir.install "libprocname.so"
      end
    end

    libexec.install Dir["*"]
    libexec.install resource("trino-cli")
    bin.write_jar_script libexec/"trino-cli-#{version}", "trino", java_version: "25"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env("25")

    resource("trino-src").stage do
      (libexec/"etc").install Dir["core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
      # Docker-only default since 484; `HOSTNAME` is not exported to services, so let Trino generate one
      inreplace libexec/"etc/node.properties", /^node\.id=.*\n/, ""
      inreplace libexec/"etc/jvm.config", %r{^-agentpath:/usr/lib/trino/bin/libjvmkill.so$\n}, ""
    end

    # Work around OpenJDK / Apple (FB12076992) issue causing crashes with brew-built OpenJDK.
    # TODO: May want to look into privileges/signing as this doesn't happen on casks like Temurin & Zulu
    #
    # Ref: https://github.com/trinodb/trino/issues/18983#issuecomment-1794206475
    # Ref: https://bugs.openjdk.org/browse/CODETOOLS-7903447
    (libexec/"etc/jvm.config").append_lines <<~CONFIG if OS.mac?
      # https://bugs.openjdk.org/browse/CODETOOLS-7903447
      -Djol.skipHotspotSAAttach=true
    CONFIG

    (var/"trino/data").mkpath
  end

  service do
    run [opt_bin/"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trino --version")

    ENV["CATALOG_MANAGEMENT"] = "static"
    port = free_port

    cp libexec/"etc/config.properties", testpath/"config.properties"
    inreplace testpath/"config.properties", "8080", port.to_s
    (testpath/"config.properties").append_lines "http-server.http.port=#{port}"

    server = spawn bin/"trino-server", "run", "--verbose",
                                              "--data-dir", testpath,
                                              "--config", testpath/"config.properties"
    sleep 30

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output("#{bin}/trino --debug --server localhost:#{port} --execute '#{query}'")
    assert_match '"active"', output
  ensure
    Process.kill("TERM", server)
    begin
      Process.wait(server)
    rescue Errno::ECHILD
      quiet_system "pkill", "-9", "-P", server.to_s
    end
  end
end
