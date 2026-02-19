class Screenpipe < Formula
  desc "Library to build personalized AI powered by what you've seen, said, or heard"
  homepage "https://github.com/mediar-ai/screenpipe"
  url "https://github.com/mediar-ai/screenpipe/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "eb3599daabc1312b5c1a7799c1ec8ab715aa02d9216a6aa42d930039c84a70c9"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e19fe81711f2b581441d5ef4e4894229ff0b40bcb7ec97620649b41ccfac3784"
    sha256 cellar: :any,                 arm64_sonoma:  "b029a73f249a978552cc4d6e7fcd35655bfc466f0f343a8dc7ef3e47feeb6f07"
    sha256 cellar: :any,                 sonoma:        "fedcdd0173129e061e5dec07b3ee9f178cabb5af29e775038a29de39eec50a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c05236a8906e59fcb9a3dd1a8fbe3d0962717af731b1d8894f70235b5b6b6cc6"
  end

  # Unable to update as newer versions need Bun.
  # Older version used by formula doesn't build with newer Rust.
  deprecate! date: "2025-08-25", because: :does_not_build

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on macos: :sonoma

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
    assert_match version.to_s, shell_output("#{bin}/screenpipe -V")

    log_file = testpath/".screenpipe/screenpipe.#{time.strftime("%Y-%m-%d")}.log"
    pid = spawn bin/"screenpipe", "--disable-vision", "--disable-audio", "--disable-telemetry"
    sleep 200

    assert_path_exists log_file
    assert_match(/INFO.*screenpipe/, File.read(log_file))
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
