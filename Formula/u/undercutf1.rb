class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://amandhoot.com"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v4.0.105.tar.gz"
  sha256 "b2fcaa200a7f6a0a7046f32846bec457e01080b8bd7bab78e1fdc53d6b4feb4d"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1f456ce62a2bdad70713410b13986b21d344a5ba6eb91925c2d09baafe2fdaa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9803c171167e49a072d6f27e0ea9f4e17091c337dafb685835aab98cede4f762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "509c5ec5d6f9340863f1dfc168ba4fc396048b35116f9bbece986415020c420d"
    sha256 cellar: :any,                 arm64_linux:       "d7d1b30fd98acddb31906d354d3dbd14395d76abf48375aba1ed43ddf914644c"
    sha256 cellar: :any,                 x86_64_linux:      "1c794daff31ef6840b714a6f3f09fc39500ba0c3c9596ae23e231e1e1b902443"
  end

  depends_on "dotnet@10"
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "mpg123"

  deny_network_access!

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "dotnet", "restore", "UndercutF1.Console/UndercutF1.Console.csproj", "--use-current-runtime"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = deps.find { |d| d.name.match? Version.formula_optionally_versioned_regex(:dotnet) }.to_formula
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
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
    bin.install_symlink libexec/"undercutf1"
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/undercutf1 --version")

    # Run in its own PTY, as .NET opens `/dev/tty` and gets stopped by SIGTTOU in the background
    require "pty"
    require "io/console"

    output = ""
    PTY.spawn(bin/"undercutf1", "import", "2026") do |r, _w, _pid|
      r.winsize = [80, 43]
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty end
      end
    end
    assert_match "Importing sessions now requires logging in", output
  end
end
