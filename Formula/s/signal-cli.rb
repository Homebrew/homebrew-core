class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.24.tar.gz"
  sha256 "c76e290f5ae5f0490eaf7b1d5fe6089d1d1305ee2bebe836cb405f976dd8dbf1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8b2ee12323eac268a1cdc3b1d611b60e4a29137b049b151cc97d04dbaa186b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58ebaf088e1ea205115aa61466964fb7f48cbfd23ed069770ff8f68d7684b8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31e1168bb0750efe27c29976a78dee301397141d0d7d96cd224bfeda1708da8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f2411058f467e49584287824cb1257e831d05d728acdcd9fe8c52eb4df14d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31370a70af92a50540bc39c3233c268b802f08fb19c8b7eb27034db0a839ccc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f765d9f1ba3e62277df7e05b21de196562088db69e45ba90c8ef3602471275"
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
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.87.0.tar.gz"
    sha256 "bfa6415dfc05cd578b0428605d57ae2474b4c7f85236122a55ffce29bc7de2d9"
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
