class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.24.tar.gz"
  sha256 "e3054ad453ac577b941f8df0eabc94e842affc6e1d10ba8d21cededfa2eacc73"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "a57fe498d64e7ad4a5130cfc31b7553f3be1ff97b9129847feaec4ac2fd7fa7f"
    sha256 arm64_big_sur:  "7cdbdf9f8925d40982367d4b61ce4bf2284bbcfc8531f1c5c1a7b36e8310a1b2"
    sha256 monterey:       "0edc7bae4a82088c6cea0b03ce77d4689e19bd76f2d75d70df0880ffc173e752"
    sha256 big_sur:        "2161c94f66ee47ea365b714ec02c676338062f1cecd905d22c43c39ae5f15149"
    sha256 catalina:       "10f5b925f7d485474d2dc9155f000ccd7ddb13aee4e8f4e0cb495bda7341ef23"
    sha256 x86_64_linux:   "0139a07a7c645bc4984fb4c1c2e211f97ce198a71077138bc74c1dbffea322f6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.24/scrcpy-server-v1.24"
    sha256 "ae74a81ea79c0dc7250e586627c278c0a9a8c5de46c9fb5c38c167fb1a36f056"
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
