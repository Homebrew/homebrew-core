class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.22.tar.gz"
  sha256 "96af955957f354cca78971be0fb54dfbd86a5b520f98a2563d3f0b0a54f4ec5a"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "26a7dade69f3af308367c8adda381e1a6c1b130c4ebbffccac7334a9d2337bba"
    sha256 arm64_big_sur:  "48b5a0edb09c3df1d9fc561a89c9467ad1f39899dbb2363c6ff75a33c051bf48"
    sha256 monterey:       "c5322e6363b076c965b0feb32a923f173aa3aa3186da3df2880872703b31b20a"
    sha256 big_sur:        "a1eb2afaaef1ecddd48f4671b83e63ebcce8c09a00f94391dd745a3eb97f7da3"
    sha256 catalina:       "a314b132944fdcf3c05f96921a5cb93932acbbf6e5bcf87f37ab952e09d97e91"
    sha256 x86_64_linux:   "2e8517fa7609e0fb6fdb0b8fa481d0d50dbe663b02572eb67e843bdf46e8999a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  on_linux do
    depends_on "gcc" => :build
    depends_on "libusb"
  end

  fails_with gcc: "5"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.22/scrcpy-server-v1.22"
    sha256 "c05d273eec7533c0e106282e0254cf04e7f5e8f0c2920ca39448865fab2a419b"
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
    out = shell_output("#{bin}/scrcpy --no-display --record=file.mp4 -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end
