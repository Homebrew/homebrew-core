class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.1.90.tar.gz"
  sha256 "cec4089f0f3185de5d851777f7b4805fa0df6c61edd1dccb4ef4aad0a2b5cfd1"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173621d296459284e8711ada683c8243f0ba1a5bf9ae4f11b1e3c1f2029239b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87303fe03f08e9ef9c29b86a8a58548a5d56c2d75c1358de67d6c43a3c8d4acc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e11408bcc3ddfaef0f75f42f570eb995537569a53364c863721a8a61273d8d15"
    sha256 cellar: :any_skip_relocation, ventura:       "a8d3c4b16c2111d04d1ea791baa2ec90c21bee67714bdb0a5da9e542c6ec8247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c034ce27e4ee20981ee12aa8738ed40b7da0391938cc44f690e2155191bf0635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "105feeb71fecf1dd3ccc7371f0b35e75dc337e41f0a64b444787716721fa9fcb"
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
    ]

    # Version override is not needed if cloning from HEAD
    args << "-p:OverridePackageVersion=#{version}" if build.stable?

    system "dotnet", "publish", "UndercutF1.Console/UndercutF1.Console.csproj", *args

    (bin/"undercutf1").write_env_script libexec/"undercutf1", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/undercutf1 --version")

    output = shell_output("#{bin}/undercutf1 import 2025")
    assert_match "Available Meetings", output
  end
end
