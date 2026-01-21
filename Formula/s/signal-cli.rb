class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.22.tar.gz"
  sha256 "b4c41e98fb7089709a035c963ce96da96428269d334d82c0789b9160a193cc4a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f885c54c7b4d559d6bf5c1f269686abf99d426c54473c8ffd89cef3c8234936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d3019b6553dd25d30806c4666e71d005902c0dda1288ba67828f204602f0f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98f1766e9d7874ba5df338ae42613d38aadef4afe2059c1ce7f8fca2225b1583"
    sha256 cellar: :any_skip_relocation, sonoma:        "9054ec90fc5e2958ab161c7296ea0ed65338578bee5540cd156972c23b678532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e9174416f57157012dde966f9618dd4f54e37818827f18f9721331b70d9fb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430dba2d671f91ef7b99a39a8171e4bba6ce73fe136cc1f9163a56384da3b796"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle@8" => :build # older version needed for `libsignal-client`
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.86.1.tar.gz"
    sha256 "6d73c0f9ae69adca57169f6e47cfa147d06f150dbee6e610cd8165873244cfaf"
  end

  def install
    java_version = "21"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    # FIXME: find a better way to handle resource version check as this can easily break
    regexp = /^## \[#{Regexp.escape(version.to_s)}\].*\s+Requires libsignal-client version (\d+(?:\.\d+)+)/i
    libsignal_client_version = File.read("CHANGELOG.md")[regexp, 1]
    odie "Could not find libsignal-client version in CHANGELOG.md" if libsignal_client_version.blank?

    resource("libsignal-client").stage do |r|
      odie "#{r.name} needs to be updated to #{libsignal_client_version}!" if libsignal_client_version != r.version
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
