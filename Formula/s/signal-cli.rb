class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.17.tar.gz"
  sha256 "40bb1259ff2e84f97d3b5f3b1d96d30bd71e614ca19b5d5572f4a67e9b944eea"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ed217f436e13704cfa805b78fa37958887c0c87156042763ed01596f7b8124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf8aa497cbec598eb51dc6e12a4a7dc5e12c5fb94b2ba973eb5050b0c4df4250"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afca07ad7d1887ff91099a793e028196a00b49f070317d0b0285c671f07e89d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed4fc0805520a7c87f9507c155de168fc3337698ea67cf070eeb7c4d292a6a3"
    sha256 cellar: :any_skip_relocation, ventura:       "68bdbffb886e8e493dc3ec7c68ec1db1fabd26859174390aba4e8022f81034f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fdba4c1309088bc12efe20eb9d58b939a942141b2df4956dd5113029f13089d"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # FIXME: Uncomment below when https://github.com/Homebrew/brew/issues/19838 is resolved
  # FIXME: on_linux do
  # FIXME:  depends_on arch: :x86_64 # `:libsignal-cli:test` failure, https://github.com/AsamK/signal-cli/issues/1787
  # FIXME: end

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.76.0.tar.gz"
    sha256 "64a78ff474e102eedeeba25838fc6f3375e6e5dcdd999be6596250bd1419268a"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env("21")

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#manual-build

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      res = r.resource
      odie "#{res.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != res.version

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni_*.so", "libsignal_jni_*.dylib", "signal_jni_*.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "client/src/main/resources" do
          arch = Hardware::CPU.intel? ? "amd64" : "aarch64"
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni_#{arch}")
        end
      end
    end
  end

  test do
    # test 1: checks class loading is working and version is correct
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    # test 2: ensure crypto is working
    begin
      io = IO.popen("#{bin}/signal-cli link", err: [:child, :out])
      sleep 24
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "sgnl://linkdevice?uuid=", io.read
  end
end
