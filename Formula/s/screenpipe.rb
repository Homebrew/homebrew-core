class Screenpipe < Formula
  desc "Library to build personalized AI powered by what you've seen, said, or heard"
  homepage "https://github.com/mediar-ai/screenpipe"
  url "https://github.com/mediar-ai/screenpipe/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "492b7b31baa2e91757085e6e2add34d03b0cc257f33a9eb7c12fbbf4ea4277c4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77308d8b5f944bf7228de456c2ba679d7cc1e67a5be2f4ddb18631743bf83e82"
    sha256 cellar: :any,                 arm64_sonoma:  "e5f48ebf2417bea35ae88c472fe4ad68c0f6773a7a312bee3e305169dacd353b"
    sha256 cellar: :any,                 arm64_ventura: "10959cbd31bea956ccca9f1b5dfb3262d1423ffbcffa84794803cb71de7af4b9"
    sha256 cellar: :any,                 sonoma:        "7ad885d4015354d5ee3c77e91366216bb12ed7c38af0e750e72380bb0b82cc3a"
    sha256 cellar: :any,                 ventura:       "45e90df2ea94269eecad00a7a9fb2d39686b7ad436b67476813011eef5271b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4685d6b5d4e1e3300b999cfd6efaf12c7c9ca87f7957dcd9fbf3b32e58d5890"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3"
    depends_on "tesseract"
    depends_on "xz"
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
