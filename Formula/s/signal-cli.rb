class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c69d2c9c0d69970bdaffb33115384f7dd35843cd4169661b7b6430272a17f50a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb66ad17399a07f800acb0771398ef0893c8f0c53b842bb7ba4b89792951f54f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc1e75f2d4d3b1adfc51177fb88f1a2991dd05ea947e107d278bbc465676a2fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81deb14654e5ca017cdcfb780aee933bbbae8e7d9be48e95e0a8c285288c0b47"
    sha256 cellar: :any_skip_relocation, ventura:        "da0720ecb4e1f18929f8ba4227d9d3eb9caa7e7fb70d959df2e5c5a591b57ded"
    sha256 cellar: :any_skip_relocation, monterey:       "b5f634cc0d90db4e94aa0bb4085c68c79a5075cb5d2cdd70afa1d9dc638a2885"
    sha256 cellar: :any_skip_relocation, big_sur:        "466d19db9733ab64ebfa3a9e3c9280e8253452e49a2fea428af16cb8351b4e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6ab13278ece9c08b29b3a41888f18f26c269c58f93f668b7380c0d8eaa76e0"
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
