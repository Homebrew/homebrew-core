class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://amandhoot.com"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v4.0.103.tar.gz"
  sha256 "58907341f4027ac6ae9019da9893655cfda41accf1fb46d2fff2d5f6fbb0c799"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4236250cad5a0f92a2c16b506395dccf4fa80fa6f7fe4fd60bddde95a609a55e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65921338437761c35764d3218bd6fc0a38ec1292b02e708417405bb22951ea51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63b6f937574ba7454fdacea9af484e4832f634738cf7eee08cec202d77e2c03f"
    sha256 cellar: :any_skip_relocation, sonoma:        "27c9d96db1f0288d5120f6ef9bf44f7d2c9cf069d36dd7da3cb6bd8bf341a8d4"
    sha256 cellar: :any,                 arm64_linux:   "f0495ad3a7d79e73642d96690c883e7fcebc2d404b56b67f06a80fa5a6b06853"
    sha256 cellar: :any,                 x86_64_linux:  "78803f5184454ff0bb05399f946a86efdad4f9204c6a067aec65ac843918cda3"
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
    assert_match "Received HTTP response headers after", output
  end
end
