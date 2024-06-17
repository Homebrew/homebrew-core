class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.2",
      revision: "e3b7748d7be7f32dcaeeed5ccd241a342635ac23"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ae45ca33cdc99fb1453e18c58f3d335e45399d9ea6dc6c6ed7c10e6c1552b658"
    sha256 cellar: :any,                 arm64_ventura:  "b29b37874d620e771995ddacc91a1634eb418a8ab6011d45fab77199548c54f5"
    sha256 cellar: :any,                 arm64_monterey: "d72679e95147af27b24199a6e9161963490e10ec3b15d28a5cd81560f0080f6b"
    sha256 cellar: :any,                 sonoma:         "9672f2efb0243b9ca04667dd34b4ee8ac9519ff569b370a748931dd9d165dde7"
    sha256 cellar: :any,                 ventura:        "256fede744b7bf3edac5fe1c30cbee5bbeb4aaacb2d9777ef524b39ae88e69c6"
    sha256 cellar: :any,                 monterey:       "52eb2123094e28bdf3e91ad26a649631da885ed3c15ba19a8c0db6116a706115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d38cf196ae21536968e3f7d874d6056cd38ab78b87cdb88480ab2ef9034c7b1c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    args = %w[
      -DUSE_PCAP=1
      -DUSE_SSL=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
