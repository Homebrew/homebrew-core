class Smapi < Formula
  desc "Open-source modding framework and API for Stardew Valley"
  homepage "https://smapi.io"
  url "https://github.com/Pathoschild/SMAPI/archive/refs/tags/4.4.0.tar.gz"
  sha256 "05a71e28cf4ab549a5c0833e4115388bce10f3a238429992061b864319c96170"
  license "MIT"
  head "https://github.com/Pathoschild/SMAPI.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "dotnet@6"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet@6"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    system "dotnet", "publish", "src/SMAPI.Installer/SMAPI.Installer.csproj", *args

    (bin/"smapi-install").write_env_script libexec/"SMAPI.Installer", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_path_exists libexec/"SMAPI.Installer.dll"
    # The installer expects an interactive terminal, so just verify it can be invoked
    output = shell_output("#{bin}/smapi-install --help 2>&1", 1)
    assert_match(/SMAPI|Stardew|install/i, output)
  end
end
