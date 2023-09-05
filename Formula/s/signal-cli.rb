class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "441526df3c62efe2ddf2421bc2ecfa727c80219957e2a01af4a0fa600a7c356e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4ca9f9ec346ff80ebb0daa8c1b422509ff9da0622a5b508a9695ee8ddb80199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "449957852a354b082d015268bbe6341fe19f39546c95549bc72bf25660e42a26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9997470bd853d93394f1f6b86216b34b341a7a7ea68d4c9b3c620db66cd2c67f"
    sha256 cellar: :any_skip_relocation, ventura:        "c7c9eabd50e2fd1564123fe62ba8503ab99d2a48f0d050ea0f3db9f8bb65cf99"
    sha256 cellar: :any_skip_relocation, monterey:       "18480f79264022f64d85b86c7088106b5fe7b8655f39058618be68af3ef38a2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "82a4aefedc6a74981e8c7e1ca70ed2efaace75f8ce7429537f009a135d1651e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ec386fc856c3efc20b60f023644d065dd2441ac19900b2d7cf2c839bf5960b"
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

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # curl -fsSL https://github.com/AsamK/signal-cli/releases/download/v${version}/signal-cli-${version}-Linux.tar.gz |
  #   tar -tz |
  #   grep libsignal-client
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.30.0.tar.gz"
    sha256 "a9fe90f35c87c85d30efed3ffa0f717196e10eba4d2a9c95fa8129e88847f7f0"
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
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#manual-build

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      res = r.resource
      odie "#{res.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != res.version

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
