class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v2.5-install-release.tar.gz"
  version "2.5-install-release"
  sha256 "8e352fcffc17c6521a975417352191d07ff6d5a807b357c093108efeb2369a43"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "1d7fe865c98fb90da644d0ddf7c81de13cc0900f5280a253528e2417fdb8f942"
    sha256 arm64_ventura:  "95ae467b41ba2bf559edb2aff33f0635107c592df1f258f972ea9f05f09b6480"
    sha256 arm64_monterey: "e7f7fc4c69f2d0bf5612847a2149d52faa6be0dcc1158db65a3b6c452aad9796"
    sha256 sonoma:         "c1b8d1cd973220b5a06821f6dd9f7dc9fb03c712fb43a7d609623c172c4ce142"
    sha256 ventura:        "ec1e4bac035b64646ea9b3c7deea19fa92819d3db7e0223f14964fc4fb910536"
    sha256 monterey:       "76e217312622f57a76e27d69cf6920729c0ff0baf4162d938dcad0eddc358db7"
    sha256 x86_64_linux:   "3406538ee4d73a93eac98005329cff4ad2e4002ce5449b3dfaa30434abafba45"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v2.5/scrcpy-server-v2.5"
    sha256 "1488b1105d6aff534873a26bf610cd2aea06ee867dd7a4d9c6bb2c091396eb15"
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
