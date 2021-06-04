class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/releases/download/v0.8.3/signal-cli-0.8.3.tar.gz"
  sha256 "56c38b4b070b44a335835275b3a05f8f047d887f6bfb410bf9e4e2e60ce1a15c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d7b81bb970d3b3405b78306125081d5c72dce3469b60e81d0d4438623e51d011"
    sha256 cellar: :any_skip_relocation, catalina: "21afac88b610cde1221d44247556cf80dcfced2d44d60ea1ff529b9f6133ee1a"
    sha256 cellar: :any_skip_relocation, mojave:   "c1ff1e88c38fccf4f2935f4eb66436596d27da0dd02310b8a9781336594d55a3"
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
    version "java-0.2.3"
    url "https://github.com/signalapp/libsignal-client/archive/refs/tags/#{version}.tar.gz"
    sha256 "730c1dc113da5227920716656d8f888e1af167208e095a8cac3de9c0d83890c4"
  end

  resource "libzkgroup" do
    # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libzkgroup
    # we want the latest release version
    url "https://github.com/signalapp/zkgroup/archive/refs/tags/v0.7.2.tar.gz"
    sha256 "fdd03bbf584533963d1be40ab238d4e6199b379e8112f6aaf5cd9493b7f1fb47"
  end

  def install
    libexec.install Dir["lib", "bin"]
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system "#{Formula["rustup-init"].bin}/rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#building-libsignal-client-yourself

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libexec/"lib/signal-client-#{r.version}.jar", "libsignal_jni.so"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", ", ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "java/src/main/resources" do
          system "zip", "-u", libexec/"lib/signal-client-#{r.version}.jar", shared_library("libsignal_jni")
        end
      end
    end

    resource("libzkgroup").stage do
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libzkgroup

      zkgroup_jar = Dir[libexec/"lib/zkgroup-java-*.jar"].first
      # rm originally-embedded libzkgroup library
      system "zip", "-d", zkgroup_jar, "libzkgroup.so"

      # build & embed library for current platform
      target = "mac_dylib"
      on_linux { target = "libzkgroup" }
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
