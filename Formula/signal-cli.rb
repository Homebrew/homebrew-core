class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "ed2fed353630891f7c6b723f13cb1e586e079eb45e31bdaf2132d9e9cd583a2c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f9c5f5fc19f195d908700fdcf99adf36d339553ab5ee16c1f6e1681b1956d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4285a73cebdba6dfe268f6a6cfebb26e789717b678ad18bd012a5cb25abbcc0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc4f92f39e35f7d485db6a83bf958e4009933f8fbc43179fd0685a51fdf25d99"
    sha256 cellar: :any_skip_relocation, ventura:        "07e9642942d3857da15e5e7708c19cd934dbd0d20e048d9f9c5ab2b7d1d1de98"
    sha256 cellar: :any_skip_relocation, monterey:       "23ab83d137735b3a07bf28d04ff62e20a607202819c61c5bc159f703c347e8c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbd97f6ae258cede6733698da8ff79df73cd96419d2144baf6e77e76eef78c31"
    sha256 cellar: :any_skip_relocation, catalina:       "9d64b9f69593d0d0b359d6d1e67b244eb2ad5934eb63661d6211db90192be46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be3e0ef34576095cda9d4f304cd4ddddb73c4d9451b2b513e9abf0705e042c09"
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
