class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "8a71f9e44681e05790f8b6ca7c9e1b2390ef80cb4403218e7cca734ea6725f4c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be92b2f441e3f6de9af8afa40047e64c0ccad26921c5f7f5d5708e735c6bc921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa33f3ed575136f34f85f20f0ac705a0b008d91d35620944707192d0db982755"
    sha256 cellar: :any_skip_relocation, monterey:       "ac7a72e097019d29d1654d54fc569db2be4b70a9da006e0bb6cb93b6ccf8dcc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6c7855fec3c3ec7eb4d1636c6301d8a311e8a205d03b44e713cc825e46fd8f6"
    sha256 cellar: :any_skip_relocation, catalina:       "21752ad740040fb288ffd1bd6d18932d78082bb4606af4092e9080f0d1db0b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec0e876eac9b67eb3f8bf7522b148656b31cc2d1337f7bab7d5d38069b1452a"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc listed in the file
  # https://github.com/signalapp/libsignal/blob/#{libsignal-client.version}/rust-toolchain
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
  # we want the specific libsignal-client version from 'signal-cli-#{version}/lib/libsignal-client-X.X.X.jar'
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.21.1.tar.gz"
    sha256 "1dd527ea0f5e7bb37c855b2e092d8b6d3ae496fd22f2c9684501c29c36c106cc"
  end

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#building-libsignal-client-yourself

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      odie "#{r.name} needs to be updated to #{embedded_jar_version}!" unless embedded_jar_version == r.version

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni.so", "libsignal_jni.dylib", "signal_jni.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "shared/resources" do
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni")
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
