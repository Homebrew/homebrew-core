class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.21.tar.gz"
  sha256 "76e16a894bdb483b14b7ae7dcc1be8036ec17924dfab070cf0cb3b47653a6822"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "2a586a677ed73bfa4ff34cc7cf67ad662973120f7e00e9ccf26913ee3e3778fd"
    sha256 arm64_big_sur:  "c37589350a0f65777ecb99f164d4c90941854d1b1517a186755f9fd2340de468"
    sha256 monterey:       "e99fb7eb6525964b5fe6d961119fa3d7a3536805a3c5e042b0fbcd78338e94fc"
    sha256 big_sur:        "8bd53e00e7c077634b9980ac4d87340ef8041498a87dd5b726a0b2d0e3fe90a9"
    sha256 catalina:       "5a6f0f41cc1cf70d498c082fd1f6815d23fea7beaca65678f87dda0325d6e489"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.21/scrcpy-server-v1.21"
    sha256 "dbcccab523ee26796e55ea33652649e4b7af498edae9aa75e4d4d7869c0ab848"
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

    # When running, scrcpy calls adb four times:
    #  - adb get-serialno
    #  - adb -s SERIAL push ... (to push scrcpy-server.jar)
    #  - adb -s SERIAL reverse ... tcp:PORT ...
    #  - adb -s SERIAL shell ...
    # However, exiting on $3 = shell didn't work properly, so instead
    # fakeadb exits on $3 = reverse

    fakeadb.write <<~EOS
      #!/bin/sh
      echo $@ >> #{testpath/"fakeadb.log"}

      if [ "$1" = "get-serialno" ]; then
        echo emulator-1337
      fi

      if [ "$3" = "reverse" ]; then
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
