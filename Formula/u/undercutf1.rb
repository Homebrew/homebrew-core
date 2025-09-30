class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v3.3.34.tar.gz"
  sha256 "98bd1ae234e80f2eaeb2116d18662807c318759402a02699ab9c76dc1da579a8"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed29cd7926fc85e3a31dfd19ec1f98fb540cd413df98b83211566f4889073d2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d470b77cbaa010b644091a37c051e9e629414b4303339c7872d8ac3e80a62a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "277c58bcd2f51dc7ad61fb8be966d16407666e7624ffae537a39daa7ae9f16ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83a2cbdc7ced5589483936baa48196a9153ef15062b61b94f6a43a6e0c6f1a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2128aaf531870ab0aac9affe5cf75e71f6f735af7969784c2aee794b38e8b85"
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
