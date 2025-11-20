class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.4.16.tar.gz"
  sha256 "2a45feb53eda7368b57f52c91a612123ad729ac5e05b51ea885df81f4df717f2"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fcf44b73d5cd1157549de0fcc48a3578ae2eaca9120bb84fa3afe5db6e2d64a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdf58baa7feedba66316dd47b0f6bb76ce5fadf8c2bdfdbfbfdf51d9b1455894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9592e8ddb352b8cd60cf1dbe1bf78e1fb59926dc8bd5da1cceacf44d7ef3136c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94031d658e5f581535d2d4fccaa237a19ff0b7c91c883e3198797264b045cbf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d239f786c0996a0dd45745e2f3e8c8a70d73675ec34b483bc742a675df6e1d"
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
