class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/476/trino-server-476.tar.gz"
  sha256 "cfd5accde17e8ebd251eeeb78aed1f490e77bb3a164d95a0f454bf8a7c1cbd3f"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9caf9aa709b5d188d268df9aafc60487021b6e8b30c27b4f93a5172a47df134d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9caf9aa709b5d188d268df9aafc60487021b6e8b30c27b4f93a5172a47df134d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9caf9aa709b5d188d268df9aafc60487021b6e8b30c27b4f93a5172a47df134d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f78192a519c995d1c42f31229b277281a5072e347bef52164e5032eadb1726f"
    sha256 cellar: :any_skip_relocation, ventura:       "1f78192a519c995d1c42f31229b277281a5072e347bef52164e5032eadb1726f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98801d4ca23627319d3a02e7328760df5e9d1ea688c80c259f3fe654c5918360"
  end

  depends_on "go" => :build
  depends_on "openjdk"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/refs/tags/476.tar.gz"
    sha256 "5a288d90f02858131387a93e9c221bed77849073fb107e6cdf0a74945ee33cbe"

    livecheck do
      formula :parent
    end
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/476/trino-cli-476-executable.jar"
    sha256 "fe4e9c7fb569cd67673afa1622945f6308e1e59bdb825419352b80887661757b"

    livecheck do
      formula :parent
    end
  end

  # `brew livecheck --autobump --resources trino` should show the launcher version which is found by
  # getting airbase version at https://github.com/trinodb/trino/blob/#{version}/pom.xml#L8 and then
  # dep.launcher.version at https://github.com/airlift/airbase/blob/<airbase-version>/airbase/pom.xml#L225
  resource "launcher" do
    url "https://github.com/airlift/launcher/archive/refs/tags/304.tar.gz"
    sha256 "4afd1ed339c64bccab54421c01317665364a5e71dec20fb6b7b2f60281f1b344"

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
