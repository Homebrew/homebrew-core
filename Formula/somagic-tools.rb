class SomagicTools < Formula
  desc "Tools to extract firmware from EasyCAP"
  homepage "https://code.google.com/archive/p/easycap-somagic-linux/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/easycap-somagic-linux/somagic-easycap-tools_1.1.tar.gz"
  sha256 "b091723c55e6910cbf36c88f8d37a8d69856868691899683ec70c83b122a0715"

  bottle do
    cellar :any
    sha256 "b0fa394d0211f43fe5c9da6e7f36b8e3b6ed5086b8a447b06df42e21bf0e30cd" => :sierra
    sha256 "b73262d08d3ec9e10645290555b5fb0c5fd95492c9d5db2ab451285ccb69eac6" => :el_capitan
    sha256 "0b0b6840133039a9f7c33579d45fbd93e68dc00e6eabe0bd4d36d7d4da56fc06" => :yosemite
    sha256 "0fad2574c7dbb306c975cb68b84a3c317965d9fab4c5b0e0787533cacf8f7988" => :mavericks
  end

  depends_on "libusb"
  depends_on "libgcrypt"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
