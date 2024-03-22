class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v2.4.tar.gz"
  sha256 "60596f6d4c11163083da3e6805666326873ed57f7defd8a20256b928a1d3503b"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "7fbdcf74ec311ba8da752faae8cc30da3d7af70cd7aa5f437edea15765eec62a"
    sha256 arm64_ventura:  "3fb95fbf9a5a4aadb4ab2d35eb93c3679e71b52a90df7b10b7627b6b38c39f59"
    sha256 arm64_monterey: "e89e1a0c634a3701e790981bb274b48a0905b108e6cbb03201988d01a82ecf83"
    sha256 sonoma:         "fadc8e8ddce26adc9703ac0ed769a01f6a22a853929698c0d96a8ab3f1f14e49"
    sha256 ventura:        "8dd7eb1490110dd2ed9f31186de437757060881a928418f7451177314004ded5"
    sha256 monterey:       "998db741b12534a698e36f4893fbc7c66f396614bda3a5d9e049d6dd92f12432"
    sha256 x86_64_linux:   "df8292347c4d57fa7341a4402a92f4b0a4353e9ed7664ba20bc5ce609871ebf9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v2.4/scrcpy-server-v2.4"
    sha256 "93c272b7438605c055e127f7444064ed78fa9ca49f81156777fd201e79ce7ba3"
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

    fakeadb.write <<~EOS
      #!/bin/sh
      echo "$@" >> #{testpath/"fakeadb.log"}

      if [ "$1" = "devices" ]; then
        echo "List of devices attached"
        echo "emulator-1337          device product:sdk_gphone64_x86_64 model:sdk_gphone64_x86_64 device:emulator64_x86_64_arm64 transport_id:1"
      fi

      if [ "$3" = "reverse" ]; then
        exit 42
      fi
    EOS

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}/scrcpy --no-display --record=file.mp4 -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end
