class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.11.9.1.tar.gz"
  sha256 "6010493063949f037cca14c4351d7270e757de4cd4fbed5b44af1448928f2e04"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09ed23eeb16a81b0f9244254521115a70974e12bdb31579930d1d05a3281204f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08116d85ebf9ea220e52125aad7ed58d96341cc6672126f2931dc7eb719109a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3734f20ccde248793435a45bf6fc64e1faa7aa1d4e62da6b9e1a8644aec1a0b3"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9d2a96e926587571005eaf8d48e8a6730339463049abd44a948b9b02373f79"
    sha256 cellar: :any_skip_relocation, monterey:       "2c717fced32485e5455e4a5a9e33119776f934eb3379f63561e8003a3ed16df7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5112be9e99c297ec84bac97bd02c6ab1e01265e0a2dd17ead4782897460f9ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "883a77e7c45bad098d86ef53720feca790b319ac6082385934d917cf3a3c9644"
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
      odie "#{r.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != r.version

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
