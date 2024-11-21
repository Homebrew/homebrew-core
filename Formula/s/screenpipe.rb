class Screenpipe < Formula
  desc "Library to build personalized AI powered by what you've seen, said, or heard"
  homepage "https://github.com/mediar-ai/screenpipe"
  url "https://github.com/mediar-ai/screenpipe/releases/download/v0.2.0/screenpipe-0.2.0-x86_64-apple-darwin.tar.gz"
  version "0.2.0"
  sha256 "-apple-darwin"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ab3cdb0a6676c440a02eebc342341017f95c0295073bf507cef513a61a704af"
    sha256 cellar: :any,                 arm64_sonoma:  "441c211f4af82c9a34053905d7f1055e24e417d715b85aba03b4b82aa8a38262"
    sha256 cellar: :any,                 arm64_ventura: "de4e7286e9a19ad32fc47aeefb60b424870171898bc9cd39bf70ef383ca0eb11"
    sha256 cellar: :any,                 sonoma:        "474e316a3d35adb731bd5d053583ad74f11735e27b11cdc8d1d69ace46631c5d"
    sha256 cellar: :any,                 ventura:       "0798f9f36e491aed26d598d744a06487d039eae71f91cb5113d6bdbe41272823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b45dcfd02154031f502f7824477a6127e6e5730bb9db7cc918bbf75539e0dd2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3"
    depends_on "tesseract"
  end

  def install
    features = ["--features", "metal,pipes"] if OS.mac? && Hardware::CPU.arm?
    system "cargo", "install", *features, *std_cargo_args(path: "screenpipe-server")
    lib.install "screenpipe-vision/lib/libscreenpipe_#{Hardware::CPU.arch}.dylib" if OS.mac?
  end

  test do
    assert_match "Usage", shell_output("#{bin}/screenpipe -h")

    log_file = testpath/".screenpipe/screenpipe.#{Time.now.strftime("%Y-%m-%d")}.log"
    pid = spawn bin/"screenpipe --debug setup"
    sleep 200

    assert_path_exists log_file
    assert_match "screenpipe setup complete", File.read(log_file)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
