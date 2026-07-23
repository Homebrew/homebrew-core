class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v4.1.tar.gz"
  sha256 "537b2ade623cb94b6edddfa5c61bf0b0af21484aa8365ea2531b686ea573249a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "051389e896b9b9de172196551bde18ec8ca804987039873c3787ee3a616a0a75"
    sha256 arm64_sequoia: "0ddd6a1cdbb32162d59d6a5c82b10dba2620a0303d15da8b3cbfbcd287ee7abe"
    sha256 arm64_sonoma:  "a0ab4986faa29588ece9af2af64de5ea404727aedb5976a4e5197bdeeb3cf1db"
    sha256 sonoma:        "68a65c9bfb9b39ece80b610692394de581de56938c706877a8bf4933f8de7c5e"
    sha256 arm64_linux:   "f52b05b8ee16ad3d0f4b7cebc653b484348ad32d33cd792de21286db96cd3056"
    sha256 x86_64_linux:  "e628feeb2e78ee412153234c93d7d6524fb05aa7d8254b26592f067db2524daf"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl3"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v4.1/scrcpy-server-v4.1", using: :nounzip
    sha256 "deacb991ed2509715160ffdc7907e47b4160eb30d1566217e9047fd5b8850cae"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "prebuilt-server resource needs to be updated" if version != resource("prebuilt-server").version

    buildpath.install resource("prebuilt-server")
    cp "scrcpy-server-v#{version}", "prebuilt-server.jar"

    system "meson", "setup", "build", "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    fakeadb = (testpath/"fakeadb.sh")

    # When running, scrcpy calls adb five times:
    #  - adb start-server
    #  - adb devices -l
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~SH
      #!/bin/sh
      echo "$@" >> #{testpath/"fakeadb.log"}

      if [ "$1" = "devices" ]; then
        echo "List of devices attached"
        echo "emulator-1337          device product:sdk_gphone64_x86_64 model:sdk_gphone64_x86_64 device:emulator64_x86_64_arm64 transport_id:1"
      fi

      if [ "$3" = "reverse" ]; then
        exit 42
      fi
    SH

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}/scrcpy --no-window --record=file.mp4 -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end
