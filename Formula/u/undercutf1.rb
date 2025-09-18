class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "4f9833b175ec3e171f1494b57aaac50ea7c2d6e1f73c7e5e0ed3a6317eb457c4"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8cd2de2e8606f1841da9a79680c81d3526a8e0a87366155b11850957e91f372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf950497b0c21db856572b8065dbda41d31b1fdaef770be7a74aa21d4ef45e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57474966c31723d9983810af80204e63f37576ba8e0ceb627a29b82e2fafac31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c81adee4cddcdf39c0d1a42834050e1a7c117593566e25e58fdd9dbb7fe7b0e0"
    sha256 cellar: :any_skip_relocation, ventura:       "024b3fde40f71021e5a95ca3b1cb0d352c4d44540aaafc6d4d68ff09735f5736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "611c6ea66dcaae71defb72a272d9f2a2005d752550a3e2ef38d2abd2fc3bae0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0b8f94a246f96cdf46fb960912b2a28ea7cb7977ef9f1d87c6dd7441cbb0e5"
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
