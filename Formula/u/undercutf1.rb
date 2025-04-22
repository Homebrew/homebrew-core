class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.0.31.tar.gz"
  sha256 "a4fbcaf68426494fa5bbd4bddb1d3877a70debbfef6a18202216828ff7116e21"
  license "GPL-3.0-only"

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --use-current-runtime
      --output #{libexec}
      -p:Version=#{version}
      -p:PublishSingleFile=true
      -p:PublicRelease=true
      -p:IncludeAllContentForSelfExtract=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:NB.GV.CloudBuild=false
    ]

    system "dotnet", "publish", "UndercutF1.Console/UndercutF1.Console.csproj", *args
    (bin/"undercutf1").write_env_script libexec/"undercutf1", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    output = shell_output("#{bin}/undercutf1 import 2025 -m 1254 -s 9693")
    assert_match "Downloading data for session 2025 Melbourne Race", output
  end
end
