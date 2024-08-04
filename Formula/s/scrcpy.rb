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
    sha256 arm64_sonoma:   "7c6c595842bf23e39e45bbefebe51e05f9c213646e8a53204a6ca3216757a5cd"
    sha256 arm64_ventura:  "51e600bc86b93f0a2e4b5f3af587430f558210d7f37175037a071de753216c8b"
    sha256 arm64_monterey: "a986a46d57a836268efa9f6ad4be0ecbd2e0d8599642b6ced293307b143cffa6"
    sha256 sonoma:         "d26eff38114ca62da12aaec65385235828890b79b1c0f30054435004d1ca07f3"
    sha256 ventura:        "60d0fbd3d3319945ba1d5c2f328bd21fce974ddbfd63cea46cb984f831f1b509"
    sha256 monterey:       "aeb3b8bd0c09fa783027a9e1efdd5bc846f06e13e83d3e7335b399c455e2484b"
    sha256 x86_64_linux:   "c01251ba0115a463f952c5ec182ade165ec134dfe296fd91cbf1f55aa14dc407"
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
