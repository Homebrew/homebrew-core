class Tunnelite < Formula
  desc "Secure tunneling to local applications"
  homepage "https://tunnelite.com"
  url "https://github.com/cristipufu/tunnelite/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "3516585b6dc9d485bf2ffc7d11da3d75ed77c374fa37dc59889cc6151dafb834"
  license "MIT"
  head "https://github.com/cristipufu/tunnelite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "353c7fe4593511ee18fb8b7867be111c7cfd00aa5bf9134f6932edfc16e032a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0df83b7480b309f55b4160a2e0b0c3f770dfd5457e0d5e43511d90b4171e58d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bc371aa798d1bf28d688083ddbbf24dd02f0b9c5c99f77c40b5847cff3873f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3f7ffde681f8ca78f0702f118babbc07f5fb955cde3dccc3711cce9cae2480f4"
    sha256 cellar: :any,                 arm64_linux:       "e0d428d6b66bfb0e6722fec0c2776f16456f6d129686b5d66b0a20e54772858c"
    sha256 cellar: :any,                 x86_64_linux:      "8a3df67049205c6238ad7a06c574a2cec8c839f3c74092cc7b0b686a4306636e"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]
    # Force a single MSBuild node: worker-node sockets are denied by the macOS sandbox (Homebrew/brew#23920)
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "src/Tunnelite.Client/Tunnelite.Client.csproj", *args

    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin/"tunnelite").write_env_script libexec/"Tunnelite.Client", env
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/tunnelite --version")
    assert_match "Unsupported protocol", shell_output("#{bin}/tunnelite ftp://localhost:1")
  end
end
