class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.9.tar.gz"
  sha256 "905fe62e2825310eeb77187f8974763c3ae2f08ca1f649bcaf4721f1fd14a764"

  bottle do
    sha256 "6b3c73d844f2e03884494b5ef35ae61e954d61deaabee3dc2c6890ea59f2c8d9" => :mojave
    sha256 "3ede1d5379b523fa49bafded248216359461d5f469f31f487317dd6b975fe2d4" => :high_sierra
    sha256 "894321121f744ff2e39557ebd913a6ba208f6f61eeb3578e8e61854091b63992" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.9/scrcpy-server-v1.9.jar"
    sha256 "ad7e539f100e48259b646f26982bc63e0a60a81ac87ae135e242855bef69bd1a"
  end

  # include the commit that fixes non portable build
  patch do
    url "https://github.com/Genymobile/scrcpy/commit/bcd0a876f7bf52642330410812a6b7100cdeda91.patch?full_index=1"
    sha256 "86444cd3e26b73cf1c48e442c7aeabc748140b3422c860ac7ebbb05a374c1405"
  end
  def install
    r = resource("prebuilt-server")
    r.verify_download_integrity(r.fetch)
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "--buildtype=release",
                      "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
                      "-Dportable=false",
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
