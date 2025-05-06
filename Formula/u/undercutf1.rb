class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.1.70.tar.gz"
  sha256 "99a9afa66e9f97596ddacea0f1cc183736f6c3ab4f9f331380bcb015b0d91ccb"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d15f3c92e58295630b9f958ec5d5b033e6ad9a66120da04245fdb5f1c17a4bed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5de72159df4ff87fdb08da169196044f390a2e5b809b9bd1f565a2b99bfeff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db29e0d5d38fd1ee455b22c7ab27d708adfeb4ee7d3678b45e463717ccd0eec6"
    sha256 cellar: :any_skip_relocation, ventura:       "de573df2e30566da948c3b5a5513e7bd6d36b6c3f9a537bd8e28d2afb10d928b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b459e3f9a31fb2890cf4aa01480360155ea5ab13d1b8e226fcf00872949e04e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e3cf23b2b82aca2461119884fd10fc9f84a1b74e14601c789adfdb7a9654d6"
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
