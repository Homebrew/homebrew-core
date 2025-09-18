class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "08bc272ac8decf364fbefb8865eaf074ba600969494ea8ade08736a6a2e3c39a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bd7184271c4970c60c9855895d0468d79fabbab35eac3e8737cd8a58d637aa7d"
    sha256 arm64_sequoia: "efb4f4018da2954270957d977b1c7f7bb8a76daba5c308792dd4d2170ae0e3b0"
    sha256 arm64_sonoma:  "9370a52679f3e2cc21044a8f3d3b1106d07707e8311ed227118aea37044291af"
    sha256 arm64_ventura: "8aa2c202f7a8184a5293196b6dd7c9d869a5ebe693cbb8cbc49f5bd75bd64294"
    sha256 sonoma:        "831e2ef31cf441305f269a0d27688eb71e8ec9003fd6cf82c0422ba2a9251074"
    sha256 ventura:       "ec31b1dc0f1c77ef83e6e451f3c9909fee29bd3e2f7c7b4060ba6c913a3c27f4"
    sha256 arm64_linux:   "b792890194094383661dca4ae3af1efc0ebb92eb797d12a54e3ce1dafcad1fe4"
    sha256 x86_64_linux:  "109b5b858b9b7113c24944b6c93d74a02fe6aebc886abf7cef8b7216b095c6ec"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v3.3.2/scrcpy-server-v3.3.2", using: :nounzip
    sha256 "2ee5ca0863ef440f5b7c75856bb475c5283d0a8359cb370b1c161314fd29dfd9"

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
