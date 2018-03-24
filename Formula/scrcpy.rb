class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.1.tar.gz"
  sha256 "1b56caa4aad5add2c49ea436e9f26282b55a413003d0d73b029a1fbf48da0a1c"

  bottle do
    sha256 "cffb7263b7a2571fa00ba7a5d2bb0b0d2a12561c55610c135eefed8018d4e23a" => :high_sierra
    sha256 "a87794ecbe2c7439ed42005c42211e749b3593c5c9d2bbbc30cf6274fc782056" => :sierra
    sha256 "8a9a1627cad91bfc4e61fe1187a23f71014bc7fd595d951dc19bbb256076500d" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.1/scrcpy-server-v1.1.jar"
    sha256 "14826512bf38447ec94adf3b531676ce038d19e7e06757fb4e537882b17e77b3"
  end

  def install
    r = resource("prebuilt-server")
    r.verify_download_integrity(r.fetch)
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dprebuilt_server=#{buildpath/"prebuilt-server.jar"}",
                      ".."

      system "ninja", "install"
    end
  end

  def caveats; <<~EOS
    At runtime, adb must be accessible from your PATH.

    You can install adb from Homebrew Cask:
      brew cask install android-platform-tools
    EOS
  end

  test do
    fakeadb = (testpath/"fakeadb.sh")

    # When running, scrcpy calls adb three times:
    #  - adb push ... (to push scrcpy-server.jar)
    #  - adb reverse ... tcp:PORT ...
    #  - adb shell ...
    # However, exiting on $1 = shell didn't work properly, so instead
    # fakeadb exits on $1 = reverse

    fakeadb.write <<~EOS
      #!/bin/sh
      echo $@ >> #{testpath/"fakeadb.log"}

      if [ "$1" = "reverse" ]; then
        exit 42
      fi
    EOS

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}/scrcpy -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end
