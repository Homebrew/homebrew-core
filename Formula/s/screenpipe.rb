class Screenpipe < Formula
  desc "One API to get all user desktop data. Cross-platform, open source, 100% local, captures all desktop activities 24/7"
  homepage "https://github.com/mediar-ai/screenpipe"
  url "https://github.com/mediar-ai/screenpipe/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "eb3599daabc1312b5c1a7799c1ec8ab715aa02d9216a6aa42d930039c84a70c9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e19fe81711f2b581441d5ef4e4894229ff0b40bcb7ec97620649b41ccfac3784"
    sha256 cellar: :any,                 arm64_sonoma:  "b029a73f249a978552cc4d6e7fcd35655bfc466f0f343a8dc7ef3e47feeb6f07"
    sha256 cellar: :any,                 sonoma:        "fedcdd0173129e061e5dec07b3ee9f178cabb5af29e775038a29de39eec50a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c05236a8906e59fcb9a3dd1a8fbe3d0962717af731b1d8894f70235b5b6b6cc6"
  end

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

  resource "bun" do
    version "1.1.38"
    on_macos do
      if Hardware::CPU.arm?
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.1.38/bun-darwin-aarch64.zip"
        sha256 "bbc6fb0e7bb99e7e95001ba05105cf09d0b79c06941d9f6ee3d0b34dc1541590"
      else
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.1.38/bun-darwin-x64.zip"
        sha256 "4e9814c9b2e64f9166ed8fc2a48f905a2195ea599b7ceda7ac821688520428a5"
      end
    end
    on_linux do
      url "https://github.com/oven-sh/bun/releases/download/bun-v1.1.38/bun-linux-x64.zip"
      sha256 "a61da5357e28d4977fccd4851fed62ff4da3ea33853005c7dd93dac80bc53932"
    end
  end

  def install
    resource("bun").stage do
      bin.install "bun"
    end
    
    features = ["--features", "metal,pipes"] if OS.mac? && Hardware::CPU.arm?
    system "cargo", "install", *features, *std_cargo_args(path: "screenpipe-server")
    lib.install "screenpipe-vision/lib/libscreenpipe_#{Hardware::CPU.arch}.dylib" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/screenpipe -V")
    assert_match "1.", shell_output("#{bin}/bun --version")

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
