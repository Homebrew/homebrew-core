class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/releases/download/v0.9.2/signal-cli-0.9.2.tar.gz"
  sha256 "0ae9ab22538f9af437c7b51ae48d86ed99534806e12e001030f520e08e5609e4"
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
  # the libsignal-client build targets a specific rustc (nightly-2020-11-09)
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  resource "libsignal-client" do
    # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
    # we want the specific libsignal-client version from 'signal-cli-0.9.2/lib/signal-client-XXXX-X.X.X.jar'
    url "https://github.com/signalapp/libsignal-client/archive/v0.9.7.tar.gz"
    sha256 "d6ba63e0147befd5901d01d24a5025d476651e3d1bf66a9991fc8e3952b54075"
  end

  resource "libzkgroup" do
    # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libzkgroup
    # we want to use the same version signal-cli uses; see 'signal-cli-X.X.X/lib/zkgroup-java-X.X.X.jar'
    url "https://github.com/signalapp/zkgroup/archive/v0.8.2.tar.gz"
    sha256 "c2f758cb96c4e49b18439c8c0ae06d129a8f46549b63a9498cf54d7d64489dcc"
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
