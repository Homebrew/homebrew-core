class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://sniffnet.net/"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "20a5ce502119be22251dd119e41a2bc069454ac1f2c553caccbace6912487180"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "470ba3bc540812ff459164a8b4a07df1f493d37fe59eec486eb443ef2b97c3b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5cf5c830fc91b990ff1b6bfc20731147f2d16e55f3bd58931d76e540d6011bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "587e92299dd32ce4e0f55baab283f27e546a69ebddb4c59a38540fd92d964613"
    sha256 cellar: :any_skip_relocation, sonoma:        "18e91e13fbd78dbbe6ca7168b1b3c042791bb0051a3bff50816f07e0412382dd"
    sha256 cellar: :any,                 arm64_linux:   "13ed1d1e6f809c4951cfefe5dbf8d02c76a4734073b62cbcad49e42d415932d9"
    sha256 cellar: :any,                 x86_64_linux:  "0c798da66aa4ac02cbafc49df585d4621a6b2c76e77f0a121fffa61bd3cfc383"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # sniffet is a GUI application
    pid = spawn bin/"sniffnet"
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
