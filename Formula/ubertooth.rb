class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https://github.com/greatscottgadgets/ubertooth/wiki"
  url "https://github.com/greatscottgadgets/ubertooth/releases/download/2020-12-R1/ubertooth-2020-12-R1.tar.xz"
  version "2020-12-R1"
  sha256 "93a4ce7af8eddcc299d65aff8dd3a0455293022f7fea4738b286353f833bf986"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/ubertooth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "eb16cfaa4f585142771941fae3f80da25fd0f27c7552c140ab4b2fdc07009321"
    sha256 cellar: :any, big_sur:       "44519c8ea1f5f557404c950922e1c4303633df759676441fbc9620d72ab012ab"
    sha256 cellar: :any, catalina:      "e08b1229ff32e200e5f6e7d562d83ce26e5dff0e50b4373f1add2a411854ebdf"
    sha256 cellar: :any, mojave:        "9e6dcaeeff6974606332371fc0ce861d679bc9d00471f4185a7531b320e581fb"
    sha256 cellar: :any, high_sierra:   "d3891c8cd1e395c8d7acd9f364d6d42d3bcb7d9d1ddd5adea9dfabc7f0aead69"
    sha256 cellar: :any, sierra:        "b4e68f3183b67bd99d276c0889e6c36ea6a1c99931446bec237d9bf7b4cc5d81"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libbtbb"
  depends_on "libusb"

  def install
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Most ubertooth utilities require an ubertooth device present.
    system "#{bin}/ubertooth-rx", "-i", "/dev/null"
  end
end
