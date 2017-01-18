class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.2.tar.gz"
  sha256 "5dd4ea0c7e97ad8e3677ff3a254b116df08a5d041c2df8859aad5c4f88d1f774"
  head "https://github.com/twogood/unshield.git"

  bottle do
    sha256 "ce0d7256b7fa9194c736f958b84121c5303246721f4d66c13dce9b103de14424" => :sierra
    sha256 "0c4970e41a434a33d58395acfdfbadf1269c50fe0c4a986dcf72882200145a72" => :el_capitan
    sha256 "435e0ded27f6febb443d73c238b3f1b198c7881fed943b3b5505cb7c24e40fcc" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"unshield", "-V"
  end
end
