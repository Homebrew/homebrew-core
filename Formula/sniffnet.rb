class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "028209240be187c9de94be4da6cd3129d5c2bd2542a929e6d869bfad4d7aa9a5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4d1f6b93705f3f91a15c36ca739c753a8d4a056bf98e530b7eff936c458f950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afff24e05223ccf351587230637bac01be37bb0b6a655eaef97981bc09850ca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f5238effbd5f62ee9fb4c6657730e0155e86877e7aa905dd0ffb84a41692728"
    sha256 cellar: :any_skip_relocation, ventura:        "06a92755bab64adc3714db5a0f3a8abf69d7422a6146f024a912a5d1dd5239c8"
    sha256 cellar: :any_skip_relocation, monterey:       "c140bd00f861d7e5e7c72692fb3145f7191da3d826873e18ac2821655bb5ba75"
    sha256 cellar: :any_skip_relocation, big_sur:        "a116e01c90511e62361806407fdeb68db188b16d39d0b421c38e8daf670cbbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fee0d3b10873016b331117eb0e72a78700c6dd3b07c645d9081127698411ed8"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = fork do
      # sniffet is a GUI application
      exec bin/"sniffnet"
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
