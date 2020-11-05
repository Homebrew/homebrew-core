class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.16.tar.gz"
  sha256 "94cbd59e26faa08ca25d5126d6c8d45e831b6a9e716ce05cd57bc4bcc751f742"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 "a24757d4dfde8f782042c2ab7beef64dd90452383cbe009c74f3009f2f9776c3" => :catalina
    sha256 "db5bda6488e199b90a604b9fbdc7da898d930c910d4375880ee2ceef85e6bf93" => :mojave
    sha256 "116cb6a0b65d32e7dfc779e644a1b8e73cd8106a0ed012895c5da0ab66296c76" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.16/scrcpy-server-v1.16"
    sha256 "94a79e05b4498d0460ab7bd9d12cbf05156e3a47bf0c5d1420cee1d4493b3832"
  end

  # Fix build on Xcode 12 (https://github.com/Genymobile/scrcpy/issues/1726)
  # Remove in the next release
  patch do
    url "https://github.com/Genymobile/scrcpy/commit/bd9f656933e79f7b21b42993f8a70a761ab47226.patch?full_index=1"
    sha256 "3ab1c2d4b9cc38fe94ae24c49c74b4008a36ffb8079442545feeffa5d3448540"
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
