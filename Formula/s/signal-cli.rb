class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.8.tar.gz"
  sha256 "acc8d89463b5cdce2cf81ad00e91caf5aec37aab2d5f57d722139f254c0fd816"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ade2e89145086de67fb439b205eeaf42ebac395761252b47ee43f694bccfd8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a823ba06b21e08c915a645cad15eaabfe76462df58fb6484b49393622d3eb73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f104ba0935a3fd15d4c2ebf5105bb0899c6bf8a745e1c4b9b402164c6adc7fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3d77c18866fca4366128b2e716c5cffc63ae937af65172e197594d0802faddea"
    sha256                               arm64_linux:       "a05108d5e62d7ab1a2e8238c99b46177e42dc162257fa56c59dc969f09a0cddf"
    sha256                               x86_64_linux:      "518da6c02eda4a5aef79e9279e7f1102fb68cbfae8c78e34e61a7c1448cc207a"
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
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.102.1.tar.gz"
    sha256 "6dfd78963083917bf03814243a1e60086a62f3fb5dbb755c194db73dd958f810"

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
