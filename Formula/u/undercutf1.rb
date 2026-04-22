class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v4.0.73.tar.gz"
  sha256 "458e4a0ec263ff742adfb36ffa76b510c0639c5e671f440f10d2db8b21e4b6dc"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a76a0957d7221443a2b0a9ffdb2da97f9da96a9aa204ced1cea24e3182a930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "636fb74fcc464a7dee3e89469cf6e0eda6a38a6c862692031a2f9f2018a5e4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7c180f328d328902a9f64626ce60a692aa2f992e1fba2e99664ad462e95ca99"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff0bd0274390a25821e1026ac4b0b65f94466b8f8b36833bc65a7aacd73692a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca39ca36ba4e65f0af2814230cbbf1a4c9a4838aee8279b64e58661e2a55f668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398f8c9c166613878887076202094aa7934cbf8309d8aa08a2a4145d4ee3d9ab"
  end

  depends_on "dotnet"
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "mpg123"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:IncludeAllContentForSelfExtract=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:EnableCompressionInSingleFile=false
      -p:DebugType=None
      -p:PublicRelease=true
      -p:PublishTrimmed=false
      -p:PublishAot=false
    ]

    # Version override is not needed if cloning from HEAD
    args << "-p:OverridePackageVersion=#{version}" if build.stable?

    system "dotnet", "publish", "UndercutF1.Console/UndercutF1.Console.csproj", *args

    (bin/"undercutf1").write_env_script libexec/"undercutf1", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/undercutf1 --version")

    output = shell_output("#{bin}/undercutf1 import 2026")
    assert_match "Available Meetings", output
  end
end
