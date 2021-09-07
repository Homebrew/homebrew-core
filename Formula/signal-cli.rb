class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/releases/download/v0.8.5/signal-cli-0.8.5.tar.gz"
  sha256 "1fcf797f223a7ddaebaa172028cc73192c4ee4116eba2ce37e3044c2f975cb28"
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
    # we want the specific libsignal-client version from 'signal-cli-0.8.1/lib/signal-client-XXXX-X.X.X.jar'
    url "https://github.com/signalapp/libsignal-client/archive/refs/tags/v0.8.1.tar.gz"
    sha256 "549d3607919f537649aa3f179681161a2ea0a08786a684c4faf2afdc7fd60aaa"
  end

  resource "libzkgroup" do
    # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libzkgroup
    # we want the latest release version
    url "https://github.com/signalapp/zkgroup/archive/refs/tags/v0.7.3.tar.gz"
    sha256 "a2df7cf3959d424d894c837f7e0062bcd819b31355196fc5bf3de4602c69e2e0"
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

      # build & embed library for current platform
      target = if OS.mac?
        "mac_dylib"
      else
        "libzkgroup"
      end
      system "make", target
      cd "ffi/java/src/main/resources" do
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
      sleep 8
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "tsdevice:/?uuid=", io.read
  end
end
