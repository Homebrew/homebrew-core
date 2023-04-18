class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "07e8bbc56eb3b54575a4ead5ce4694b037006d2890ecabff2b44b04e9d9a11c1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "584f8bac2e6303db71c75cbd51351ec58a1b27e0670dbdcbd2ba58d7c7ea1027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05a9f48ec78b3af64a69f4b64e4f1c85a78a4c5c44a09a967f01778b9d42b5f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24d5d3b5b5dbf7221f0bebb144aa7ee2b10266622265e41bee63efefbb3cc0d8"
    sha256 cellar: :any_skip_relocation, ventura:        "6632b105017a0ecee0c4da726410bcafb7c5476add5e3a00a01b552ee968c4df"
    sha256 cellar: :any_skip_relocation, monterey:       "2988554f1ec72118d9a2dd57c2837bdc0235f0291bdf89d7ce56e01fedede15a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1d18310680d99f212d35573ac69b54c48c2bf0a6c867d3dd84b01735a2c86f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68405272c33fde906b906de06f05b728e38f3046ae7a0e311a616b28ead14e47"
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

  uses_from_macos "zip" => :build

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # rust-lang/rust-bindgen#2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `libsignal`
  # crate's dependency `boring-sys` uses `bindgen` v0.62.0 or newer.
  on_linux do
    depends_on "llvm@15" => :build # For `libclang`, used by `boring-sys` crate
  end

  # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
  # we want the specific libsignal-client version from 'signal-cli-#{version}/lib/libsignal-client-X.X.X.jar'
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.22.0.tar.gz"
    sha256 "fed130fe6192e7cb422d8278a5ee4a7451ea62f5cbfd68bbacd5350513e0bad8"
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
