class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.2.tar.gz"
  sha256 "d340e3a0aa1625161bc00068ffccbe291b7866729a5fff7ff859904480ec0df3"

  bottle do
    sha256 "b46f843a8569c69e1b99301e0a69335f443c870df3eead3ad78fa3c141b93a21" => :high_sierra
    sha256 "4bdcb5d23d7b1852aec8e181001af014fd255be58176e58a9b5eb9bf2e68733f" => :sierra
    sha256 "c33b30a90c2f801987349a3f958bb6b1e35e44b4d3fe7ecbd9016eb3c32f0020" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.2/scrcpy-server-v1.2.jar"
    sha256 "cb39654ed2fda3d30ddff292806950ccc5c394375ea12b974f790c7f38f61f60"
  end

  def install
    r = resource("prebuilt-server")
    r.verify_download_integrity(r.fetch)
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dprebuilt_server=#{buildpath/"prebuilt-server.jar"}",
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
