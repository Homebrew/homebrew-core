class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://amandhoot.com"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v4.0.89.tar.gz"
  sha256 "80541923a4d7296bc39355848429627428a58d5de5cd5765115be38bb02bbf1b"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0cc53e858084ef9faa6f27253ff89ad1c9542816d0944fa26d5cfe83d7c5f53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39b38c84d1370aa2f47b6538c9e9c0c3bdb356dee808664d5f182a7aa511d10e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31f64c2801511624db8738326e9881ba0b0ea296677d89f046012c498f21c7d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a97dab65fd5398f7e147c086151bc18a6f22a3e092be4a6cda1d0bc0e3d38c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "225b9500ce33d7b241fddc6fe9d89f4343c09b8fa2918ea7a8ff4bf999778aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ccb562d136d8d494fd2ff75d0dbef8ab47d6a6598bd279454e548d10f702b56"
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
