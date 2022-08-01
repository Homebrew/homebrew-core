class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.10.10.tar.gz"
  sha256 "69f333421e7c681410093694fb953053967d01aaf6e806a4d3a6b7818726940a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f4ff5620e0c890b2a621c9ba522aac60a80f8df08fe9662e85689da4b396a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31a625d6e6b1d9697f6b83ecaa8ed4c43e6f379a4fc741abc84240d401acd58b"
    sha256 cellar: :any_skip_relocation, monterey:       "f787aa0e6dba537d100638bea4b852ad941a9c3d77b01c4e9eda7a5cfc9fee2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cad7d039ad10cc0e5854054dda84d8c387874c1b311a3bb5658360d42771ef10"
    sha256 cellar: :any_skip_relocation, catalina:       "eadfd5943a3a8d04aa0e386d651ecfaf0d0bc532ba83c4d95a2a06ee35eb9bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ccbf8835f16a1c8ee8d4f60d9cfb7a22383c6507b824f0e3dbb7768d568255"
  end

  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc listed in the file
  # https://github.com/signalapp/libsignal/blob/#{libsignal-client.version}/rust-toolchain
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  uses_from_macos "zip" => :build

  # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
  # we want the specific libsignal-client version from 'signal-cli-#{version}/lib/libsignal-client-X.X.X.jar'
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.18.1.tar.gz"
    sha256 "de54535a5e9dbc0cea2eaf72d8e2f257e5c66f17b746be8d1ec3daa9d2d68f24"
  end

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install Dir["build/install/signal-cli/*"]
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#building-libsignal-client-yourself

      libsignal_client_jar = libexec/"lib/libsignal-client-#{r.version}.jar"
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
