class Undercutf1 < Formula
  desc "F1 Live Timing TUI for all F1 sessions with variable delay to sync to your TV"
  homepage "https://amandhoot.com"
  url "https://github.com/JustAman62/undercut-f1/archive/refs/tags/v4.0.105.tar.gz"
  sha256 "b2fcaa200a7f6a0a7046f32846bec457e01080b8bd7bab78e1fdc53d6b4feb4d"
  license "GPL-3.0-only"
  head "https://github.com/JustAman62/undercut-f1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "302e10741259f18b9f721879691bda15959a9a49053f15ec878ae26058c4fd1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "daed5f234b490217d0b48a58df0fadad2817ce037889d96a053172395e4aef89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2429309a4acd4e1552be2bae62ff42c9fd321734979f0eecb881fb7dd27a378b"
    sha256 cellar: :any,                 arm64_linux:       "6cf866e7b33e5118977f50494a715e8ed629d21d02ee653d90aeb39429d09a36"
    sha256 cellar: :any,                 x86_64_linux:      "947e6963962f0c2648392c5e0bfcad7060905812c43be5fe6e9be4a23b837acc"
  end

  depends_on "dotnet"
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "mpg123"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

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
