class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "08b56db45109e351c8f41bd73e05bcb1e29bae9c51783d51b8c3c4996ac83a7b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3ce340f5a05132a27e42f7dd152d1a7613739ff93eaacb278845af46934495a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de95d88bdcfa1f475d19db09804e777a244111fb2597000c55fc214ad9c73a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a85b23ce3a18673a206dd47c1bdeafb986a686385258b01d2992117e6ca648c"
    sha256                               arm64_linux:   "1e08d35808c020a77bf25be7689efac65640fc2acbdb0c5e639402b8238e9b23"
    sha256                               x86_64_linux:  "952a0de34ddadf04208d389b6fd25bfff70a91a1a9fd6414fda2508ae8a321e5"
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
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.99.1.tar.gz"
    sha256 "c6d92f2bc37902b7269fb9aac451e1047a87a812a9b7c37ba8a489ab6c6cd206"

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
