class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://www.wildfly.org/"
  url "https://github.com/wildfly/wildfly/releases/download/42.0.0.Final/wildfly-42.0.0.Final.tar.gz"
  sha256 "6c2e50b8f3e2c0c3ad8f5241e18276f12bfd3e6e37b750e3fe1d6ce1dd2800ce"
  license "Apache-2.0"

  livecheck do
    url "https://www.wildfly.org/downloads/"
    regex(/href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e15ba595522ebff78f2a3f47cbf76604712f5972da053e739bee05b9c912e954"
    sha256 cellar: :any, arm64_tahoe:       "e01973832f9f060ee7986e6309d7483883f1d72e83663c3a61af0e7939e3c321"
    sha256 cellar: :any, arm64_sequoia:     "ca64ad72e71315d85e54617590a638adae720940286ab64382164fad5cd9e8b4"
    sha256 cellar: :any, arm64_linux:       "6a6207427b143a2bf17cc40b73faf5c8892f9f7357fc9eaedc45a74a28c32473"
    sha256 cellar: :any, x86_64_linux:      "5fcf40f36811f08903598d1e60355ad564625b1bc2b7582d76519a270efbc93c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "openjdk"

  on_linux do
    depends_on "cmake" => :build
    depends_on "libaio"
  end

  resource "artemis-native" do
    url "https://github.com/apache/artemis-native/archive/refs/tags/2.0.0.tar.gz"
    sha256 "b19033e702398dd794130e123f9f3978868f67ff9667c8354b48488ac7a3d4ea"

    livecheck do
      url "https://raw.githubusercontent.com/wildfly/wildfly/refs/tags/#{LATEST_VERSION}.Final/pom.xml"
      strategy :xml do |xml|
        xml.get_elements("//project/properties/version.org.apache.activemq.artemis.native").map(&:text)
      end
    end
  end

  resource "netty" do
    url "https://github.com/netty/netty/archive/refs/tags/netty-4.1.139.Final.tar.gz"
    sha256 "eb1da5afe6042b6a2c4a0dfe7cdd20afacffdf9d855a7ec802202e1ac44392d5"

    livecheck do
      url "https://raw.githubusercontent.com/wildfly/wildfly/refs/tags/#{LATEST_VERSION}.Final/pom.xml"
      regex(/^v?(\d+(?:\.\d+)+)(?:\.Final)?$/i)
      strategy :xml do |xml, regex|
        xml.get_elements("//project/properties/version.io.netty").map { |item| item.text[regex, 1] }
      end
    end
  end

  resource "wildfly-openssl-natives" do
    url "https://github.com/wildfly-security/wildfly-openssl-natives/archive/refs/tags/2.3.0.Final.tar.gz"
    sha256 "a70e8c04759f2acc8088f885a2c505c2000f1b247514c47e731e6ce1ae345992"

    livecheck do
      url "https://raw.githubusercontent.com/wildfly/wildfly/refs/tags/#{LATEST_VERSION}.Final/pom.xml"
      regex(/<version\.org\.wildfly\.openssl\.natives>v?(\d+(?:\.\d+)+)(?:\.Final)?</i)
      strategy :xml do |xml, regex|
        core_version = xml.get_elements("//project/properties/version.org.wildfly.core").map(&:text).first
        next unless core_version

        core_url = "https://raw.githubusercontent.com/wildfly/wildfly-core/refs/tags/#{core_version}/pom.xml"
        core_page = Homebrew::Livecheck::Strategy.page_content(core_url)[:content]
        next unless core_page

        core_page.scan(regex).map(&:first)
      end
    end
  end

  def build_artemis_native
    libdir = buildpath/"modules/system/layers/base/org/apache/activemq/artemis/journal/main/lib"
    on_macos do
      rm_r(libdir)
      return
    end

    libartemis = shared_library("libartemis-native-#{Hardware::CPU.bits}")
    arch = "aarch64"
    on_intel do
      arch = "x86_64"
      # Make sure the install paths are correct
      odie "Unable to find #{libartemis} in #{libdir}!" unless (libdir/"linux-#{arch}"/libartemis).exist?
    end

    rm_r(libdir)

    resource("artemis-native").stage do
      # Maven 3.10+ rejects a Maven coordinate as `parent.relativePath` and can't load enforcer 1.4.1
      inreplace "pom.xml", "<relativePath>org.apache:apache</relativePath>", "<relativePath />"
      with_env(CMAKE_POLICY_VERSION_MINIMUM: "3.5") do
        system "mvn", "compile", "-Pbare-metal", "-Denforcer.skip=true"
        (libdir/"linux-#{arch}").install "target/output/lib/linux-#{arch}/#{libartemis}"
      end
    end
  end

  def build_netty_transport_native
    arch = "aarch_64"
    on_intel do
      arch = "x86_64"
    end
    os = "osx"
    ext = "jnilib"
    io = "kqueue"
    on_linux do
      os = "linux"
      ext = "so"
      io = "epoll"
    end

    # Make sure the install paths are correct
    netty_dir = buildpath/"modules/system/layers/base/io/netty"
    common_dir = netty_dir/"netty-transport-native-unix-common/main"
    common_jar = "netty-transport-native-unix-common-#{resource("netty").version}.Final-#{os}-#{arch}.jar"
    native_dir = netty_dir/"netty-transport-native-#{io}/main/lib/META-INF/native"
    native_lib = "libnetty_transport_native_#{io}_#{arch}.#{ext}"
    odie "Unable to find #{common_jar} in #{common_dir}!" unless (common_dir/common_jar).exist?
    odie "Unable to find #{native_lib} in #{native_dir}!" unless (native_dir/native_lib).exist?

    rm_r(netty_dir.glob("netty-transport-native-unix-common/main/*{linux,osx}*.jar"))
    rm_r(netty_dir/"netty-transport-native-kqueue/main/lib/META-INF/native")
    rm_r(netty_dir/"netty-transport-native-epoll/main/lib/META-INF/native")

    resource("netty").stage do
      # netty lacks a `java27` profile, so JDK 27 falls back to unsupported `-source 1.6`
      # PR ref: https://github.com/netty/netty/pull/18099
      mvn_args = %w[-DskipTests -Pjava26]
      cd "transport-native-unix-common" do
        system "mvn", "install", *mvn_args
        common_dir.install "target/#{common_jar}"
      end
      cd "transport-native-#{io}" do
        system "mvn", "package", *mvn_args
        native_dir.install "target/classes/META-INF/native/#{native_lib}"
      end
    end
  end

  # https://github.com/wildfly/wildfly/blob/main/docs/src/main/asciidoc/_elytron/OpenSSL.adoc#building-the-native-library
  def build_wildfly_openssl_natives
    arch = "aarch64"
    on_intel do
      arch = "x86_64"
    end
    os = "macosx"
    skip_check = false
    on_linux do
      os = "linux"
      on_arm do
        skip_check = true # JAR doesn't have arm64 linux library
      end
    end

    # Make sure the install paths are correct
    libdir = buildpath/"modules/system/layers/base/org/wildfly/openssl/main/lib"
    arch_libdir = libdir/"#{os}-#{arch}"
    libwfssl = shared_library("libwfssl")
    odie "Unable to find #{libwfssl} in #{arch_libdir}!" if !skip_check && !(arch_libdir/libwfssl).exist?

    rm_r(libdir)

    resource("wildfly-openssl-natives").stage do
      cd "build/#{os}-#{arch}" do
        system "mvn", "compile"
        arch_libdir.install "target/classes/#{os}-#{arch}/#{libwfssl}"
      end
    end
  end

  def install
    rm buildpath.glob("bin/*.{bat,ps1}")

    # Replace prebuilts with source-build native binaries
    build_artemis_native
    build_netty_transport_native
    build_wildfly_openssl_natives

    inreplace "bin/standalone.sh", /JAVA="[^"]*"/, "JAVA='#{formula_opt_bin("openjdk")}/java'"

    libexec.install Dir["*"]
    (libexec/"standalone/log").mkpath
  end

  def caveats
    <<~EOS
      The home of WildFly Application Server #{version} is:
        #{opt_libexec}
      You may want to add the following to your .bash_profile:
        export JBOSS_HOME=#{opt_libexec}
        export PATH=${PATH}:${JBOSS_HOME}/bin
    EOS
  end

  service do
    run [opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml"]
    environment_variables JBOSS_HOME: opt_libexec, WILDFLY_HOME: opt_libexec
    keep_alive successful_exit: false, crashed: true
  end

  test do
    ENV["JBOSS_HOME"] = opt_libexec
    ENV["JBOSS_LOG_DIR"] = testpath

    port = free_port

    pidfile = testpath/"pidfile"
    ENV["LAUNCH_JBOSS_IN_BACKGROUND"] = "true"
    ENV["JBOSS_PIDFILE"] = pidfile

    mkdir testpath/"standalone"
    mkdir testpath/"standalone/deployments"
    cp_r libexec/"standalone/configuration", testpath/"standalone"
    spawn opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml",
                                           "-Djboss.http.port=#{port}",
                                           "-Djboss.server.base.dir=#{testpath}/standalone"
    begin
      sleep 10
      system "curl", "-X", "GET", "localhost:#{port}/"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end
