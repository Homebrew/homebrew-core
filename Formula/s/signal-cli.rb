class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "feb98997af67eddba4a7284334aabae381ca26aede85d9e5703098b76f8779ef"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bcede52702ae1087a7dec4ad017ffc431abe90d2c81b63bc4016e917b256483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46513251087b15c7ea2178c24988a58a5d072eefd8239c2121efcb2410772dc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62c581425ccbef9424ce4f2b472cd6d89a105a851e55acb787dde4dca3fe32ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f98f14fe5322466cf2d32e7c9835286786ecd1412635f9ce0ecc759418d8959"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2919981ce025827e537cadbaa0c211df91a25d0cebf98582e92f9d418809ac8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e85f3f47bf5861ebaae27e48fd0d9ef6701f0beb8f4b4d7fc15e6c9de014067"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.92.1.tar.gz"
    sha256 "5ad152a5eec8789f8e7a3b9d85d1e356cdb6177bd273b4e174e2e477b5930502"

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
