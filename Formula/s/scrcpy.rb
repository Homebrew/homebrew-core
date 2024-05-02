class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v2.4.tar.gz"
  sha256 "60596f6d4c11163083da3e6805666326873ed57f7defd8a20256b928a1d3503b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "50ae5100944caee2fb98ee68766a124822c6b981998057052c60f94a8f17ded6"
    sha256 arm64_ventura:  "bc0db20754cf6f069b7e5159208e8ebdaf6c4407a2deda8a379da368488f5be1"
    sha256 arm64_monterey: "65bc818c9a9a54896ffbc2a4af5bfd7835d793d8f79a1b812472fc498c81dec5"
    sha256 sonoma:         "f62672fd35bfc3e512a6aad7d5fd6a0595bccb38e14bfaa6134cbc0aa829cdbf"
    sha256 ventura:        "501a4e7673f201635eddcd743914ab3865989aa21dc00e15bd43c5da56dfd37a"
    sha256 monterey:       "58bed9cf4e04545bc372867e877041a327261f6d36ea126ece2b1967dd5006fc"
    sha256 x86_64_linux:   "fcf8197e0c8dbf9dbc3a92bebbb2650d0ca6c3ec21420133c2109a97041a4c14"
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
