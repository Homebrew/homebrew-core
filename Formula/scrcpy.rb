class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.19.tar.gz"
  sha256 "40ac2059618f18a0e6f9cd0e40d3bff240ade98664bd619422f875bff7e8c70e"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "0fd6c2d4d56cdbc09df21e7a8aabbeaa75a7658f99eb8478bdfd6b97d510dad6"
    sha256 big_sur:       "6c960c8555c710cd1058e256b34e6c93be8b3294a6b34bbc58ead2344d6da740"
    sha256 catalina:      "c6262834293a4667e870ec7977e90fe1b5dda59d646555f9c71435195ac4a970"
    sha256 mojave:        "1c5e721c141ecb90418ccf5500756c94bf48c2dc1ead190e6cc16024b5449430"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.19/scrcpy-server-v1.19"
    sha256 "876f9322182e6aac6a58db1334f4225855ef3a17eaebc80aab6601d9d1ecb867"
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
