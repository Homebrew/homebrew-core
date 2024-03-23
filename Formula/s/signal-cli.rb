class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "8e77fe9af2482b38c7aababc40a59b295476f774ad8223aa52b6be1e414dc702"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "383ed9ca39f3c5682d622eb66536653129e0d694a6a53818effa75f4c5a589c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d349f32ba1f57b6a99b516cf7374700126bcf0ade3779de8a379c67b2e6ac78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9966d25eff29d589efcc405d94c08395cab79019a4dfa51cefd4d997450b14"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2c9de893a6eb48811561ad1c035dd9990103ecafa8820ae17cb108898fe4938"
    sha256 cellar: :any_skip_relocation, ventura:        "e588be4882c8b19e6342d533c0319d6b7cdb295c872f242e199d1788f0b6affa"
    sha256 cellar: :any_skip_relocation, monterey:       "448a803aa0a84ea2b5ccd2c8e7233c7862fbe8a4fd9dda441ccf2695f22745b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ee2bb4d420d1155f9718e6d8ed9593718be06b41f71a5a7d2cb3057442f2e09"
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
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.40.1.tar.gz"
    sha256 "78bec66c1721b768204bf8cd6deb4a380b3c2c82197d298381c55f306f965f35"
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
