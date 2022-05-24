class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "ae3daee59260b5caed71f4a0932aabca4def00a10db66661757c3f8d89b15640"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f56845ffbc044eee8cfd3bbc4ebe54ae36f371e8c2d8c78bb1dc44af3497b88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c757fd7c254365eec49ddf47a2eac405639e4e6ceb3d6ed31e93131a7e0d31a"
    sha256 cellar: :any_skip_relocation, monterey:       "4546d017de20147a56dfea543f4265dc86d8f1e56e676c14b3f4a63ec157c431"
    sha256 cellar: :any_skip_relocation, big_sur:        "f53ecbd1e92637d505a243d9796e4bdc74cf83bc5e8bef22e56a3bbe147ba1c8"
    sha256 cellar: :any_skip_relocation, catalina:       "5efa132d490e9f641118c24617b8f83c00c972d180a9d7e6f465038920e1013f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3461ed1c1884c69eb212fc2b166440fa0032aee067d86174f7a17179ef5dcc3f"
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
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.17.0.tar.gz"
    sha256 "7866ae9679c482a16dc4ef3fd3891e558ce0615234e7e775f887190782a88b63"
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
