class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.22.tar.gz"
  sha256 "96af955957f354cca78971be0fb54dfbd86a5b520f98a2563d3f0b0a54f4ec5a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "59768ed3efe593f13a4e31e8f453d900831b12bb8e3c54df62f86506507fc959"
    sha256 arm64_big_sur:  "4addfd8e6ec9085feb6e34623a9ebf5e7f9ff5edff1c44b6bad5876c1e43de41"
    sha256 monterey:       "ded9a0b4a2f570d208f7dc9ee356d2e3da6f92d8bcdc3b7fcb419b98e78311a0"
    sha256 big_sur:        "55cb39602e08bd145155fe3fd62d45b76d1ccfa39d4872468f1e77c64e0ae1ff"
    sha256 catalina:       "b65c45d00c6230efae98959adf95e8a50512c579f449ca61a7c0fb77d956299e"
    sha256 x86_64_linux:   "e373e64e6a5fa98720d76cb393679bd856705c055db9944e2e783495ec15859a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "sdl2"

  on_linux do
    depends_on "gcc" => :build
    depends_on "libusb"
  end

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.22/scrcpy-server-v1.22"
    sha256 "c05d273eec7533c0e106282e0254cf04e7f5e8f0c2920ca39448865fab2a419b"
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
