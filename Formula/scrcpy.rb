class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v2.1.tar.gz"
  sha256 "57a277238d19d3471f37003d0d567bb8cde0a2b487b5cf91416129b463d9e8d5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "377d2a7bd33053faf0861fbe5df9f04b7f651646de0f575d60e76a27309a5673"
    sha256 arm64_monterey: "5c1d61d40f75cb272d24622ec35db67c0f04ffb7f01fbedd72c1e8d0ce159f33"
    sha256 arm64_big_sur:  "e748d76342930edb0f07474db7fb6b8ff5fa5e63fed0d3a5ee3dd3dcc3879b2e"
    sha256 ventura:        "8f7ca4259cc329348b8ce713552a5b3a93f2579c4f46f6e1695e949f8cd7dd01"
    sha256 monterey:       "292d716519a8edd0c910697bfdc830b5c1e87c104fb671ecf3ba820036df6406"
    sha256 big_sur:        "622da142ed07c9992f250e2b48d2ded1d8a38c7787c69b477a4ee3394d31819a"
    sha256 x86_64_linux:   "f55e4abd6e708f6416d0c7eb2b2ea98a458447d8c8c489b98594dfddcd4cc394"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v2.1/scrcpy-server-v2.1"
    sha256 "5b8bf1940264b930c71a1c614c57da2247f52b2d4240bca865cc6d366dff6688"
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
