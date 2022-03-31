class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.10.4.2.tar.gz"
  sha256 "6e08761881352576e6683fcc9f6060b55aa90e5d6306695b7378ed9b9d96a197"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c01bb52171d4519538e80c7e674a642e2868d028fb7d5e988e2fa7651ae620b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a113e18096174f4d0e69d37fa12f7c5ff3a7051c1279f07ecf7d56600981efb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd1943cfe050cf2ad6bcb6e02ad727eadf8e18e8da77a0d7ac8439f131d9ce80"
    sha256 cellar: :any_skip_relocation, catalina:       "39898b369f9a94d98d486c59b2c5ccf235236344287d5186b68cefb2f9136e09"
    sha256 cellar: :any_skip_relocation, mojave:         "b04fba6a346787064b2fc20965f9bbc49be2ae751f2566e92a2f6bd77bd240eb"
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
  # we want the specific libsignal-client version from 'signal-cli-#{version}/lib/signal-client-java-X.X.X.jar'
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.12.3.tar.gz"
    sha256 "788a8f3263656844d7a140e0201cbf6c21f0da52a153deb0fe689ba3bfe67c43"
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

      libsignal_client_jar = libexec/"lib/signal-client-java-#{r.version}.jar"
      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni.so"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", ", ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "java/src/main/resources" do
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
