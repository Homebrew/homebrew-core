class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.10.tar.gz"
  sha256 "71bd3b01f26233d73b91c0953ce004bd3195bcfd0c83b76c269094fb06e5ffa5"

  bottle do
    sha256 "3424b91b362905cb2140fde701a4a89107d9ea65919d5b9b04f22b136400fe5c" => :mojave
    sha256 "5a82192ee21b66b11f726db20857f386ba75ece9fae6796363ff02f604a53dd6" => :high_sierra
    sha256 "ddf29ffdf4e935f86de8a2ee5ff2c434a1472414624f48cf71aefc62557e0b03" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.10/scrcpy-server-v1.10.jar"
    sha256 "cbeb1a4e046f1392c1dc73c3ccffd7f86dec4636b505556ea20929687a119390"
  end

  # fix build (https://github.com/Genymobile/scrcpy/pull/695)
  patch do
    url "https://github.com/Genymobile/scrcpy/commit/c05056343b56be65ae887f8b7ead61a8072622b9.patch?full_index=1"
    sha256 "dc6019d262884b9d925c7b6c5f9cad56f73f12ecc6291d052764b658e56c0fb4"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "--buildtype=release",
                      "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
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
