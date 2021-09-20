class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/releases/download/v0.9.0/signal-cli-0.9.0.tar.gz"
  sha256 "c24f2493e3c6d27c36384ee671c1a33f8df9484cad4ad472d6e9f183a12a3fff"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "91e965d7fd5503abac2dabbacb446bb907c314bb2b525db248e006f0cc3524de"
    sha256 cellar: :any_skip_relocation, catalina: "bb047f149ca74d57c93156f43c62007cb5d5e9dcd8e143c25bdf3ed0bb79f87c"
    sha256 cellar: :any_skip_relocation, mojave:   "1bd352f48bd3b9c4bf592c66722d50cda5c72f5918a22ada762ef84206c2d928"
  end

  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc (nightly-2020-11-09)
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  resource "libsignal-client" do
    # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
    # we want the specific libsignal-client version from 'signal-cli-0.9.0/lib/signal-client-XXXX-X.X.X.jar'
    url "https://github.com/signalapp/libsignal-client/archive/refs/tags/v0.9.0.tar.gz"
    sha256 "7caa3a337190d473052a7e84cb7b2cfdb83b59209bfab30ed68b2c346637d54e"
  end

  resource "libzkgroup" do
    # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libzkgroup
    # we want to use the same version signal-cli uses; see 'signal-cli-X.X.X/lib/zkgroup-java-X.X.X.jar'
    url "https://github.com/signalapp/zkgroup/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "6479d00f7b4f5acab3694c6970849502879f6fa82a74ab2879d7128d79a42007"
  end

  def install
    libexec.install Dir["lib", "bin"]
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system "#{Formula["rustup-init"].bin}/rustup-init", "-qy", "--no-modify-path"
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

    resource("libzkgroup").stage do
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libzkgroup

      zkgroup_jar = Dir[libexec/"lib/zkgroup-java-*.jar"].first
      # rm originally-embedded libzkgroup library
      system "zip", "-d", zkgroup_jar, "libzkgroup.so"

      # https://github.com/Homebrew/homebrew-core/pull/83322#issuecomment-918945146
      # this fix is needed until signal-cli updates to zkgroup v0.7.3
      # use the same version of the rust-toolchain used in libsignal-client
      inreplace "rust-toolchain", "1.41.1", "nightly-2021-06-08" if Hardware::CPU.arm?

      # build & embed library for current platform
      target = if OS.mac? && !Hardware::CPU.arm?
        "mac_dylib"
      else
        "libzkgroup"
      end
      system "make", target
      location = if Hardware::CPU.arm?
        "target/release"
      else
        "ffi/java/src/main/resources"
      end
      cd location do
        system "zip", "-u", zkgroup_jar, shared_library("libzkgroup")
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
    assert_match "tsdevice:/?uuid=", io.read
  end
end
