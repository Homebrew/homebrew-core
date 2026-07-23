class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "a3835dc86f11b3f7c89f7e11e8d25ee47b9f7571f2b94bf940b52deb2b933bb5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b271df28507b4be2e5f81ec990e88d521d136355a232a2718d4df725289d68c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c02dc046eea1e14aa686c5c7db35b6ca54fa9527e7574a688adf1d695b1c831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15324ba9baa4561b09d82fede8062ca845d4268abece6a2e44edac28084c7bd1"
    sha256                               arm64_linux:   "f0166f7c5c93d2356986c6bdb01d084b203e4ce5641a2543f6335745dba08fd2"
    sha256                               x86_64_linux:  "7df33c8b1596ec6ff2736a83b334f899ce459dd96e5522417769c6ae1ef1640d"
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
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.96.3.tar.gz"
    sha256 "a890eda2421e5062487983aa460942666b3cdf42f2875ac726a3fe9a214683bf"

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
