class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v4.1.tar.gz"
  sha256 "537b2ade623cb94b6edddfa5c61bf0b0af21484aa8365ea2531b686ea573249a"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "645018bb3c49bf575317e28c286e9c27b79c378044b774bef8a0061a97857417"
    sha256 arm64_sequoia: "c52aeac3da0f31a41357daec5b29e9c739cce303c8d4425db14c28c7064eefec"
    sha256 arm64_sonoma:  "3138af17805ee58bf974e234863402c5f4e829004f6113b80e52ee39c011ae32"
    sha256 sonoma:        "d0f1333995560049557f0258839bda2cb4895964f7b9579a79af267033f24dff"
    sha256 arm64_linux:   "cbc29f4775bccc612a2a6a1758348770c8b7d9b783b5485f7716d3ffac997b60"
    sha256 x86_64_linux:  "6fc8bd0bcfb4b15d52997791f58cbca8cde6536f95ffed1156c6394fbe269bce"
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
