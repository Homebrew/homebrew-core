class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "8c7b089b38e683349cc9d407d20f7db6b86730bc1c926263c0129ffd76692325"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96a899c3079c676228252ad45b328d877b87373a49eaf0279b004b6e074b6e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11917008165ac445c5b80c5cdac5606ab70950583408ce94c9fa59aae0cf1932"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57cb52621adde081f08a478f37e6219859d7085a2aabc2c1539b45dd6fc29c1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d574ac0b39357ae927f5cad71234c60a7c134f81f39eb3e43aa169dae0f23d93"
    sha256 cellar: :any_skip_relocation, ventura:        "679fb53a9c81304b66b2be35f60ce67a696b33e50d8be3acb7eac6d8bf5739da"
    sha256 cellar: :any_skip_relocation, monterey:       "8b53e1c538b507f4a5ef5641827ec38551b343c55f6764fb598568266ed43692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b15582142924e52da6ddc6b87c26785a4f33882e0770e82b203f97718c6944e"
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
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.32.1.tar.gz"
    sha256 "4751e197d798555c6e8c9a869c41692ed3c72a4d34738c28c6f6a1761044e777"
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
