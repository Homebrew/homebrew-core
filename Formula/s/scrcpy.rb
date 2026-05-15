class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v4.0.tar.gz"
  sha256 "a62bc2639e1d56b3e7ebaa20d8deb4947dd02954b3362bdebe2ef9f7eae41b00"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "eabcf80c0dbf37cc934f115f4c1f0a245439c61849be9c72c1edf1a21042d05e"
    sha256 arm64_sequoia: "cb7e5b0ae72ab7617e4e060fd6402ad3a0d56cb8585a6d5a3180e2e30a8f811b"
    sha256 arm64_sonoma:  "be6e7f37c3993a0edc3f00a0f2d3bd1d7db2301147323530143dc728e78d714c"
    sha256 sonoma:        "7bb41ddd18585288d2b3beb05c406e0dd16a9d0bc434800e50fa533966c26509"
    sha256 arm64_linux:   "a1d3eb81ee74c829b9dd6a329c5df28cdc68886271dcf1ee6f48c4b5c4c363c6"
    sha256 x86_64_linux:  "6048206364fcf021a887f856c8100a88db8f0621e459f9b9e267695fef43c35f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl3"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v4.0/scrcpy-server-v4.0", using: :nounzip
    sha256 "84924bd564a1eb6089c872c7521f968058977f91f5ff02514a8c74aff3210f3a"

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
