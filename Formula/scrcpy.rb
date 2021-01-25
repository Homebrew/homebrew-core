class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.17.tar.gz"
  sha256 "c16f1fe1789290d0c7dd3a2778f33d6dc6347ffe3e78e64127b85eda52420d7f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 "bc5af06f2c3de38ac6a5f6bd46ff0f8a048fcf610f1909065ed670112021f53e" => :big_sur
    sha256 "c66169f203ac1714e6f632989c1b15c95907a67f943efd38303945a4d24f136f" => :arm64_big_sur
    sha256 "55b97c706cc08908698b79d9d46bc091bcd746111ed834fbaa32a43f85833bfc" => :catalina
    sha256 "f954665b6b5d479a4f6329e66cd3f8256fbb5ba165ac418f5a9bb2820e57c547" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.17/scrcpy-server-v1.17"
    sha256 "11b5ad2d1bc9b9730fb7254a78efd71a8ff46b1938ff468e47a21b653a1b6725"
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
