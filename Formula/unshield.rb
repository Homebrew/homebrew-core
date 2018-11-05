class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.3.tar.gz"
  sha256 "aa8c978dc0eb1158d266eaddcd1852d6d71620ddfc82807fe4bf2e19022b7bab"
  head "https://github.com/twogood/unshield.git"

  bottle do
    sha256 "3eb010944609343bdb70c6ef06178b214bfda38131ca8e4bc6271e6f492e9fa9" => :mojave
    sha256 "e7352ba9971014d7320e63942231f97443f2b0895742ca9ede3aca2972b9b66a" => :high_sierra
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
