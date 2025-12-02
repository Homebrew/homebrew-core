class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.4.32.tar.gz"
  sha256 "3e90ccd0c7f02240c9ff8b175c84a37b62cb82774a62d46b44ee7103996dd30a"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6dced13a74ab4be86e42598f3060fc793c02124845dcd0bbd01fe75d98435c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c981c163aeb31b4bd9c2f78b981a498d48177c878e1adb4bbbead2eccea15a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "604e94c8900e985742ab199a4fea8a599737e0575d9ae9ed8604d315915641f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34ed8f66628d4bf90ca53ebd6ec69b531c44377b0efc1518406a0d8849b85d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b0b4cc8d05958e111c9f918c3c96141b83ef99dae3ca48df9c2ff6018d116f9"
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
