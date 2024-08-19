class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "4948474f1494fdff852a0a7fa823a0b3c25d3ea0384acdaf46c322e34b13e449"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2a611dde83725f361b2bcba85156a37c872353e602afc24b363ae9ba4c9650df"
    sha256 arm64_ventura:  "2470c7ec01faf6fc3aee531abbb916fa8a042363050ce267a1d3df9fbad0431f"
    sha256 arm64_monterey: "b30584bbb426a7544684a0a8791f914424f08de59bdba0ec1a5f48ae19e9e028"
    sha256 sonoma:         "ba1cfef97e9f9390cf6f81e5ca05a28522f2fabb144e6b7b62b80b6d276d9cc2"
    sha256 ventura:        "2a90d0436c33d2569a1fc47022f03359b39518273ba4f3595fe9efb0ef721336"
    sha256 monterey:       "7df647ca2269e1ad8ad68da2d52b4ee21b6497395fd4b5c823eacb32674ea6c4"
    sha256 x86_64_linux:   "174bcbe00d23a459721fcfcfc99b7155380e679bdcbb966b6e3b91195300084e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v2.6.1/scrcpy-server-v2.6.1", using: :nounzip
    sha256 "ca7ab50b2e25a0e5af7599c30383e365983fa5b808e65ce2e1c1bba5bfe8dc3b"
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
