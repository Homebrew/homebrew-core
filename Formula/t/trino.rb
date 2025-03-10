class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/472/trino-server-472.tar.gz"
  sha256 "9fba8cbc593f07e0fcb8fe55d44956e99412b7817106c979b306c28313cc6ded"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf70f9698c1dac9c120467670cffc7ad149706b54edda218814393bf387c4254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf70f9698c1dac9c120467670cffc7ad149706b54edda218814393bf387c4254"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf70f9698c1dac9c120467670cffc7ad149706b54edda218814393bf387c4254"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f8bb27342cf756944cdc66656c5f4182cab93793e8860f010eee1a66cabf5c3"
    sha256 cellar: :any_skip_relocation, ventura:       "9f8bb27342cf756944cdc66656c5f4182cab93793e8860f010eee1a66cabf5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b84832d1333092cb734e687856c8ffcdf0e1f86f7b2077e64c2600501ac097dc"
  end

  depends_on "go" => :build
  depends_on "openjdk"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/472.tar.gz"
    sha256 "3bb5a4ae8f9a797110f49ae728bee6266cd2194561b11326a1901e91ebbc7ae4"

    livecheck do
      formula :parent
    end
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/472/trino-cli-472-executable.jar"
    sha256 "ff2df904ea7b88750a615dbb840246acd15fcbb3990842bbb8dd8748088ef59a"

    livecheck do
      formula :parent
    end
  end

  # Update by finding airbase version at https://github.com/trinodb/trino/blob/#{version}/pom.xml#L8 and then
  # get dep.launcher.version at https://github.com/airlift/airbase/blob/<airbase-version>/airbase/pom.xml#L225
  resource "launcher" do
    url "https://github.com/airlift/launcher/archive/refs/tags/303.tar.gz"
    sha256 "14e6ecbcbee3f0d24b9de1f7be6f3a220153ea17d3fc88d05bbb12292b3dd52c"
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
      ldflags = "-s -w -X launcher/args.Version=#{r.version}"
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
    bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-src").stage do
      (libexec/"etc").install Dir["core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
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
  end

  def post_install
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
    server = spawn bin/"trino-server", "run", "--verbose",
                                              "--data-dir", testpath,
                                              "--config", testpath/"config.properties"
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?

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
