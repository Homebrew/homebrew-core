class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.9.tar.gz"
  sha256 "2316adb253a97cb9e35911303362386ca0c1b19515a886a4824ac95e6706191b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "755ec857ec3afc9454bfc10e2c99a017bd109b76cbd524d58d1cfdc045ad15d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0de875ca0bd04700733848af01f0cd72cb4cce57ea15b3fb68fdbdea12c8b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26dbf9e093c752c42c77a1a4cbdd37ba12cb408e9bba856b6766ddd15269c048"
    sha256                               arm64_linux:       "cffe44d2432f455c3447cf3135ba989b25f94a0620defed0a1b78eda151e36d3"
    sha256                               x86_64_linux:      "6b220cb64201e88affa41b732562d0cf14cc3805e9782284ce5e543ce0856ee6"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "docbook-xsl" => :build
  depends_on "graalvm" => :build
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "libxslt" => :build
  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "python" => :build
  uses_from_macos "zip" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.103.0.tar.gz"
    sha256 "c16e8b7e647a81f498050294f75ad6675d474cc5fce6bb8d26e3152044579d82"

    livecheck do
      url "https://raw.githubusercontent.com/AsamK/signal-cli/refs/tags/v#{LATEST_VERSION}/libsignal-version"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end

  def install
    ENV["JAVA_HOME"] = if OS.mac?
      formula_opt_libexec("graalvm")/"graalvm.jdk/Contents/Home"
    else
      formula_opt_libexec("graalvm")
    end

    native_image_env = ENV.keys.grep(/^HOMEBREW_/).map { |key| "-E#{key}" }
    ENV.prepend "NATIVE_IMAGE_OPTIONS", native_image_env.join(" ")

    # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal
    resource("libsignal-client").stage do |r|
      libsignal_version = (buildpath/"libsignal-version").read.strip
      odie "libsignal-client needs to be updated to #{libsignal_version}!" if r.version != libsignal_version
      system "gradle", "--no-daemon", "--project-dir=java", "-PskipAndroid", ":client:jar"
      buildpath.install Pathname.glob("java/client/build/libs/libsignal-client-*.jar")
    end

    libsignal_client_jar = buildpath.glob("libsignal-client-*.jar").first
    system "gradle", "--no-daemon", "-Plibsignal_client_path=#{libsignal_client_jar}", "nativeCompile"
    bin.install (buildpath/"build/native/nativeCompile/signal-cli")

    cd "man" do
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "make", "install"
      man1.install Dir["man1/*"]
      man5.install Dir["man5/*"]
    end
  end

  test do
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_RUNTIME_DIR"] = testpath
    link_output = +""
    IO.popen("#{bin}/signal-cli -v link", err: [:child, :out]) do |io|
      link_output << io.readpartial(1024) until link_output.include?("sgnl://linkdevice?uuid=")
      Process.kill("KILL", io.pid)
    end
    assert_match "sgnl://linkdevice?uuid=", link_output
  end
end
