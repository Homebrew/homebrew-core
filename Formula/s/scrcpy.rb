class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v2.2.tar.gz"
  sha256 "9c96ce84129e6a4c15da8b907e4576c945732e666fcc52cf94ff402b9dd10c2c"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "73212d81ed72e2dc05f1e5701b5c17c225577784f4f661c131583dca7407f0b7"
    sha256 arm64_ventura:  "289b84db363109e5f5e323746faaf6eec406b1ca15b763f6fe71b1f50b0383d6"
    sha256 arm64_monterey: "ecdb0f7a3561d941173fbb8b3f192f25fcfb2ecb83192fcf9ac52badc886eeaa"
    sha256 sonoma:         "79fc5596e771c94c3be6a9157ce39e9d2d29e97e3a03c35235c8944384fabbe1"
    sha256 ventura:        "59c590414183162b069c5d539307ce9404c1e86dd93f47406924e908238cedc4"
    sha256 monterey:       "4a2337591843767fd63056089b55b80c8e4c8afd052d2d8d90fe767332992fe9"
    sha256 x86_64_linux:   "8563d61ddc10a510ebe575e02fcec61be8c77482cd9b5e2ed10f4c507f362c3b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v2.2/scrcpy-server-v2.2"
    sha256 "c85c4aa84305efb69115cd497a120ebdd10258993b4cf123a8245b3d99d49874"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath/"prebuilt-server.jar"

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
    assert_equal version, resource("prebuilt-server").version, "`prebuilt-server` resource needs updating!"

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
