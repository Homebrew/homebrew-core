class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "1cd277437a658a892029ead7eff6be9d3ce9358f631bef3ed7f10d5294230f48"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a63a4a4248e869a31ab394b8019e99f91b6dd32d552fb1b230606a3151f418d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a58ea32aeb54f0566855c2da1125bf475606f770820a291d6b32e993781c323e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "532809d0afbcfbf0d15cdda4321a8d15615908aa121f7731c87773e022230f72"
    sha256 cellar: :any_skip_relocation, sonoma:         "caff0099be2427cc9631482be49ba97ac8363c113c2046207cc10462566a57f0"
    sha256 cellar: :any_skip_relocation, ventura:        "2cc09c215647615e3dd895efb93b4e1b3ec794bac45021779121991ac87712d8"
    sha256 cellar: :any_skip_relocation, monterey:       "6bcf4b96a68200f3cd60b8faa038cfab34cd0c3c5ab0a7e490ed5e5256537ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ded05cd4658566af2fe13af420575c6936347f2d2d9049333a878699f870dc"
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
  # url=https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.36.1.tar.gz"
    sha256 "5b16d6826c11471aee4d0c7756878164dba3ff583def2803ee6be488e3d7d2ab"
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
