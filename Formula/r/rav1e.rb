class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "2580bb4b4efae50e0a228e8ba80db1f73805a0e6f6a8c22bee066c90afb35ba0"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "418639465dc358883b2855811433ec6a74f5ae7ff45ef20701afcccda4a2b1a9"
    sha256 cellar: :any,                 arm64_sonoma:  "e8e6cc2235e8c4cd8e53a20c8a53314b8de22551d876b730eccb0531d788aa07"
    sha256 cellar: :any,                 arm64_ventura: "770faad426e3056b3527b135165cc81862b8cbe598e9c50606455e974dacfc6f"
    sha256 cellar: :any,                 sonoma:        "13a955da9cea55b1350ad3e1ba8c59eb4b10c781881228d243b8fa443156e10c"
    sha256 cellar: :any,                 ventura:       "26c11b1ebf71c587585925538e0138f5cf33405e96ffaf66506d695374c17f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e9eeace72c7630aad3bb366cd6fd58a1a73af7d94109915249a1ba02a4e2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d05384401af34ea7317d5ee4b195421f6e28372dd616733a1b48d7e002335e"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--prefix", prefix, "--libdir", lib
  end

  test do
    resource "homebrew-bus_qcif_7.5fps.y4m" do
      url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
      sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
    end

    testpath.install resource("homebrew-bus_qcif_7.5fps.y4m")
    system bin/"rav1e", "--tile-rows=2", "bus_qcif_7.5fps.y4m", "--output=bus_qcif_15fps.ivf"
  end
end
