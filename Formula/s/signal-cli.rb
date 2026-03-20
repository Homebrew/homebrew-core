class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "8d8d3a5bffcde757b8a9cb5f5e544525e8a7fd85aaa554a1fce06300b3ab27a4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7cfcca5f4603ddf90052025005484acab71531d75c0399d2961c07af299b0ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b457d14f6a981139d62dd2f989c6e7a6f54063de4b6c9dbcee2cebcca45383a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acb0af93a75940b06a71f1fe526e2ea4f22598d5a7c99a4ea17afbc0a914b8fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5af4c98f66c70ab954546061dab8f8729fb5a52073017a4a681a288083d36fba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "846d5383b5fd4d9e3ac877f9800716359a81288aee9d3ae58324af112168b6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d7af34ac93584d83e27dce3fe4f139f3a35e4661e14ba8b23edec683f458db"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.87.4.tar.gz"
    sha256 "76b7e851475846e33c1dd0a95d60806a7db001c0911f28ff8903843a22ea8adf"

    # Workaround for gradle 9.x
    # PR ref: https://github.com/signalapp/libsignal/pull/653
    patch do
      url "https://github.com/signalapp/libsignal/commit/88cd7aa21e1d8db12188c8126f87d47182ae4d6c.patch?full_index=1"
      sha256 "2c37d16b01cfc4bb62a56c6e8c3ba762c47affdcfc983bb33f5510eb99124d72"
    end
  end

  def install
    java_version = "25"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    # TODO: Update if upstream start using machine-readable dependency versioning,
    # see https://github.com/AsamK/signal-cli/issues/1964
    changelog = File.read("CHANGELOG.md")
    current_version_pos = changelog.index(/^## \[#{Regexp.escape(version.to_s)}\]/)
    odie "Could not find version #{version} in CHANGELOG.md" if current_version_pos.nil?
    # Search from the current version header forward; the requirement may appear in a prior release section
    regexp = /^Requires libsignal-client version (\d+(?:\.\d+)+)/i
    libsignal_client_version = changelog[current_version_pos..].match(regexp)&.captures&.first
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
