class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.1.96.tar.gz"
  sha256 "ff377e4bf8403510dcbe29dfbe6a9b2056234ca762dd96094943eba47618b744"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539fbd3440783df46b6619222491729137e8d3488094cd59ef7e0e35334011f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "487f2d6ee9da701aecb3d23b90875fec7f23e4c775667d210073daf3e056089c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f73cb7559c624e924bba7384c3bfdc2ec0648f0e9070ea83de2eacdbbc2f4e08"
    sha256 cellar: :any_skip_relocation, ventura:       "7817cd318fff6fe788129fd6af7c922f5c826d806ce4e99928037861ad476fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e43e3142b9893aa45bd62ed879d907481c4e6a64c320cafa76e329a6f87bf25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba9e0f377439c2d4832e6391783eb42943e1bcab85ec9d96fece3b42f05cd22"
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
