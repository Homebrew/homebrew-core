class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.4.tar.gz"
  sha256 "35d47bfe934bfdd219d879f0f62bb15cac1b7a70c03ef9e1f123e9c2d4cdb767"

  bottle do
    sha256 "d3276d256dc6e91693f8be9e29919030a48bfce19d5e5b8aef0560f4ade1651e" => :mojave
    sha256 "9ff0449c75627c66a8f3ff460d2f29d82c3c0b5dd8683505e5b31fe71046998f" => :high_sierra
    sha256 "3ae88ade610e35876b445d4e131d45f5ab749f9609f249622e7e5b18d6bbe999" => :sierra
    sha256 "ce7cb275debd8c8b47287ba87bac562705b8660985822c22aaff4f1140374b9e" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.4/scrcpy-server-v1.4.jar"
    sha256 "1ff7a72fcfe81dadccfab9d6f86c971cd7c7f38f17196748fe05480e301b443d"
  end

  def install
    r = resource("prebuilt-server")
    r.verify_download_integrity(r.fetch)
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "--buildtype=release",
                      "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
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
