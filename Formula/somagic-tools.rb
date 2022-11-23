class SomagicTools < Formula
  desc "Tools to extract firmware from EasyCAP"
  homepage "https://code.google.com/archive/p/easycap-somagic-linux/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/easycap-somagic-linux/somagic-easycap-tools_1.1.tar.gz"
  sha256 "b091723c55e6910cbf36c88f8d37a8d69856868691899683ec70c83b122a0715"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "adf9589e1d98e6eb49dc00765508d920b9f2acd79a91d92da79033f1a9aa8957"
    sha256 cellar: :any,                 arm64_monterey: "37c12048bc0e6e020317c308bf89b4b7725b483c8b4dde598b83beda176839f7"
    sha256 cellar: :any,                 arm64_big_sur:  "072982afa9d598410ddab9dd2ef09298a4f5b080b11eb982e1b6c5ba23a441b4"
    sha256 cellar: :any,                 ventura:        "14d78478d89843bf095cc9bfe37d1df550b9344f7d5453d7a54ae61a55febb7a"
    sha256 cellar: :any,                 monterey:       "6307d97300f3ba6bdd7b8d63c3fcf01dba6329713e5fefb1c81c042f07fb0041"
    sha256 cellar: :any,                 big_sur:        "e96911a936eb3ed42923f4cba1f29dcc96f624ea5f6209b153b0922ee529d20e"
    sha256 cellar: :any,                 catalina:       "59d88127409e26497afa4bb7d3afa04820dd1ccb56542096e01c85c733e53045"
    sha256 cellar: :any,                 mojave:         "70fc5f4c86296e08ca0ba835a37fb1bbdd9149892777dd6b39d83d367f2dec1b"
    sha256 cellar: :any,                 high_sierra:    "121e3b6667ee8dcd81cf2331342d27b6221b1ebf955f83e00311176fa5fe11ca"
    sha256 cellar: :any,                 sierra:         "b0fa394d0211f43fe5c9da6e7f36b8e3b6ed5086b8a447b06df42e21bf0e30cd"
    sha256 cellar: :any,                 el_capitan:     "b73262d08d3ec9e10645290555b5fb0c5fd95492c9d5db2ab451285ccb69eac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a63036040014c766c494998f69b3be27f0ff5dccee6deba1a0f8ac7c6a05e3"
  end

  depends_on "libgcrypt"
  depends_on "libusb"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
