class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://github.com/JustAman62/undercut-f1"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v4.0.51.tar.gz"
  sha256 "6a184d20b7b702460fb98235117458100975a98a779c65a7f1e1c1268001fabd"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b7a5f5b53e0c5553c84fe4490cef6ccdafc55145665f0e87645087fe6850c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b516d1b359779eac22910c1f2326c2fd5eb224abe3bbadd1a5e188e7089e6de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26674eee940ac4ab72d0a6f30d8e732cf1cc110905eb3ce5fd9cb13515a0c938"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b49db28c4dcde729a4bbb4e09bfff9caebf594b3dc3fb834c0fef708c3c3a9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cf95b851d59f25d78028d86c58e41d9142c6b42aebae3e0c4a7854e091968bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4376ea7d47c46563d49a5110bc4e653019a1c305c500093c9c20e39d2363d4f"
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
    assert_match "Available Meetings", output
  end
end
