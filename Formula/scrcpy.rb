class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.24.tar.gz"
  sha256 "e3054ad453ac577b941f8df0eabc94e842affc6e1d10ba8d21cededfa2eacc73"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7c9893c55d2ab4aa52726d18cfd70f8693b37078d968676c649ec2b55d5986d9"
    sha256 arm64_monterey: "47d05857b4a23bed97eab4d80397de5f715f7cf6bd3a2540502257556301dc1c"
    sha256 arm64_big_sur:  "9b605a35272fbc97501a42fb4fe36ff4e905c93024960164cd25b3c9c67cc754"
    sha256 ventura:        "d2868b912b3b7ddaabc6538d609ba84024711f7f73fc611573e82cd871d9c276"
    sha256 monterey:       "2833aad9c0d864e65b856c5ba851ac693c8976c9a764676c01771988db5ab32d"
    sha256 big_sur:        "b91ae2ece8a03a940b137eff536787d70b355ae1ac8d644d02a87c0c6584e442"
    sha256 catalina:       "99ef49bd7345805aba38a7b054eae73ba556862c8fdea6f4014642f761589dd9"
    sha256 x86_64_linux:   "1340efc7dec46c1d6b2fc1d51741a5ad7b197323f831d8095eaf324b99706437"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libusb"
  depends_on "sdl2"

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
