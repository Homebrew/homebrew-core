class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.21.tar.gz"
  sha256 "76e16a894bdb483b14b7ae7dcc1be8036ec17924dfab070cf0cb3b47653a6822"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "1493098a11c7ec1ae351fca71a817e5203b3a5398ecfb522bc80c92c68b06cde"
    sha256 arm64_big_sur:  "7fadf0708fd9f2b220b69753778bee7c9eb36567d36ec6d715a5d6c7bef4c6da"
    sha256 monterey:       "6e0ad67e3469cee34e8c1ba584630200a57d366531e1f732532f6cff8b351e2b"
    sha256 big_sur:        "cf5c7c1bd463e1654a0a4d795dbf6700a9cfebb6a409aa315cd758a070073afa"
    sha256 catalina:       "5eb45bf3851d6b3d79f04429977c54c02fd915c6d01f399a5ccdbc95d25d8618"
    sha256 x86_64_linux:   "cb9f1de049f42509af987720d6085cfb4b0553b2ae32f733b96572bc7a9388e1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  on_linux do
    depends_on "gcc" => :build
    depends_on "libusb"
  end

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.21/scrcpy-server-v1.21"
    sha256 "dbcccab523ee26796e55ea33652649e4b7af498edae9aa75e4d4d7869c0ab848"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
                      ".."

      system "ninja", "install"
    end
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

    # When running, scrcpy calls adb four times:
    #  - adb get-serialno
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~EOS
      #!/bin/sh
      echo $@ >> #{testpath/"fakeadb.log"}

      if [ "$1" = "get-serialno" ]; then
        echo emulator-1337
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
