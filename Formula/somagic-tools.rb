class SomagicTools < Formula
  desc "Tools to extract firmware from EasyCAP"
  homepage "https://code.google.com/archive/p/easycap-somagic-linux/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/easycap-somagic-linux/somagic-easycap-tools_1.1.tar.gz"
  sha256 "b091723c55e6910cbf36c88f8d37a8d69856868691899683ec70c83b122a0715"

  bottle do
    cellar :any
    sha256 "e96911a936eb3ed42923f4cba1f29dcc96f624ea5f6209b153b0922ee529d20e" => :big_sur
    sha256 "072982afa9d598410ddab9dd2ef09298a4f5b080b11eb982e1b6c5ba23a441b4" => :arm64_big_sur
    sha256 "59d88127409e26497afa4bb7d3afa04820dd1ccb56542096e01c85c733e53045" => :catalina
    sha256 "70fc5f4c86296e08ca0ba835a37fb1bbdd9149892777dd6b39d83d367f2dec1b" => :mojave
    sha256 "121e3b6667ee8dcd81cf2331342d27b6221b1ebf955f83e00311176fa5fe11ca" => :high_sierra
    sha256 "b0fa394d0211f43fe5c9da6e7f36b8e3b6ed5086b8a447b06df42e21bf0e30cd" => :sierra
    sha256 "b73262d08d3ec9e10645290555b5fb0c5fd95492c9d5db2ab451285ccb69eac6" => :el_capitan
    sha256 "0b0b6840133039a9f7c33579d45fbd93e68dc00e6eabe0bd4d36d7d4da56fc06" => :yosemite
    sha256 "0fad2574c7dbb306c975cb68b84a3c317965d9fab4c5b0e0787533cacf8f7988" => :mavericks
  end

  depends_on "libgcrypt"
  depends_on "libusb"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
