class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v2.1.1.tar.gz"
  sha256 "6f3d055159cb125eabe940a901bef8a69e14e2c25f0e47554f846e7f26a36c4d"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "8fd1ae7b9d4241048a218f99475f29fac9650d3de7ff527a68524975fe1b47d9"
    sha256 arm64_monterey: "6a2d920d0763d1fac9facd4d59bc43273eeea22e867c2ac73a4a7d8f1ce6be43"
    sha256 arm64_big_sur:  "4c1b82c9e96fe9199c70b89ba1a6cc8da1796d1b206e3844d885e8d1d51d0e35"
    sha256 ventura:        "28cfa8ce0b627b22a52bba40b140d5db462f6325d02a964206f4302f02af784e"
    sha256 monterey:       "aeac2ec3ab6cb3b6a5bec2c59601893f4cead77c76f7cbad4d6116a3b61d4601"
    sha256 big_sur:        "269024b209605443de8393a698a9e6d528f4bc8fb72a605749894d53f0def49f"
    sha256 x86_64_linux:   "f3d222c2d5df53ccfb7af83d4a96fd1acb89c5c07456f91344205411062e9a51"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v2.1.1/scrcpy-server-v2.1.1"
    sha256 "9558db6c56743a1dc03b38f59801fb40e91cc891f8fc0c89e5b0b067761f148e"
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
