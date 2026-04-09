class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "b9df4f8be106e7ee69902fc4eb944b87c5c3117fe5bcd2306246130d86749dbf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aef763bb544d91b45134fe2fbc1258dcfd075f1409fd2a64c3b4c09e4d2eebc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b709e96104926a00734aaafaf7dc592377ad27efe7e6f9158770b10fb0f71403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dbbb70bb72b3f34c054b4d9ee3cd80c0cdfb16060118d95d999f73ff80b6c84"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d9863ba9280fe24494104e691f6990bc2ca3a8ce9ffc5fb1f19e2f3257c6a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b8c4c06b0bab71b4e12c1592257954c1daba72de8eedc990deb05a85d7161e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "342627b3280d85fadd085a33f11316adecafeae5921c91ff59a230d9e67c69ca"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.90.0.tar.gz"
    sha256 "8b09956cbd6a58a1aafe96e5681b4d49c59c1c2ee03839d9b5ad25d5f347f520"

    livecheck do
      url "https://raw.githubusercontent.com/AsamK/signal-cli/refs/tags/v#{LATEST_VERSION}/libsignal-version"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end

  def install
    java_version = "25"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal
    resource("libsignal-client").stage do |r|
      libsignal_version = (buildpath/"libsignal-version").read.strip
      odie "libsignal-client needs to be updated to #{libsignal_version}!" if r.version != libsignal_version
      system "gradle", "--no-daemon", "--project-dir=java", "-PskipAndroid", ":client:jar"
      buildpath.install Pathname.glob("java/client/build/libs/libsignal-client-*.jar")
    end

    libsignal_client_jar = buildpath.glob("libsignal-client-*.jar").first
    system "gradle", "--no-daemon", "-Plibsignal_client_path=#{libsignal_client_jar}", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env(java_version)
  end

  test do
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

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
