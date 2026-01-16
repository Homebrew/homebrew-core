class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.4.32.tar.gz"
  sha256 "3e90ccd0c7f02240c9ff8b175c84a37b62cb82774a62d46b44ee7103996dd30a"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fc68891a534638218604c7c01baec8acc61c581357e22715f12df0a9d393991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e228fa87e578f3049427dfc59586e38b1f1d6cfca29169c1ee27fd03b0e3fda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e265140152d66e401b4ee41d7eda1756235cc341fd05cc3901e72a02375a0d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "943bacbb0c6d4ffed72770b51c8b5228ba735e1c8d2736f64be2f327e53c4f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8217e2a97d90119c30a47d8f8369fb7bf9c6d07401bf0f46be8deb94662b9018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3674c96f9266e772f647e8bf73f47b6ae3622fc5b9042d1ffe1f5b12b3bd1451"
  end

  depends_on "dotnet"
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "mpg123"

  # Support dotnet 10 - remove in next release
  patch do
    url "https://github.com/JustAman62/undercut-f1/commit/2ae7e47daab9250d31878a92943864fabd04db59.patch?full_index=1"
    sha256 "b51d288893a1ce6e5abfe759f498ce79d2ebcc5c17ab6b328c16d5ad8f2a1a06"
  end

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
