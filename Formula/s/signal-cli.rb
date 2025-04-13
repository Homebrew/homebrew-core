class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.14.tar.gz"
  sha256 "7d44e71a8c4f2087057e8ce401d416d963a62b9819a75884f3c426b28af8a947"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "091f552478e2e504bfc6424991d0e2b7cdeb4021581723c0634fab9ad81641ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed2d7e7033a16a0a07279d3c9a8b43650767f085b3750a1c96a6bcead71b2730"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9048424260dbe7a5cf827f3deb4258ab44bc7cdbcba664ca0a873e6fcea2d76"
    sha256 cellar: :any_skip_relocation, sonoma:        "231ec9f4c31b0752179c5c1337acf1175e8eb23023040f1ebe5f487aa889c8a8"
    sha256 cellar: :any_skip_relocation, ventura:       "48088e637526d484e84dfc1df6a23a68abd8109d840d3bbb4574c5ce282fa1c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a8fbaa6d6f83eb4af4ad97e7bff6a9dc777879dc651b0a8c4c4d28e84b485c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63887767ad751ca9f2a16e3f0eb64f1d44eca4a3db4f458205a3881c90d127df"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.68.1.tar.gz"
    sha256 "bc5b78d6c4cd5e2c47d24ea9c41b1047cdead0d315c6a48a1daece03eb449eb5"
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
