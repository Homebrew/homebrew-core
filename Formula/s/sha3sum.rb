class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://codeberg.org/maandree/sha3sum"
  url "https://codeberg.org/maandree/sha3sum/archive/1.2.3.tar.gz"
  sha256 "507140ec7d558db70861057d7099819201a866b4c5824f80963e62c10a0081b4"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01fb95cb06d33d483f8387411d26a4866742c42de5b444a55c380b4c4297c948"
    sha256 cellar: :any,                 arm64_monterey: "a738b5d0e3688dc6e767ab227c3247ac954b3c6cb240c6892514985958948d8e"
    sha256 cellar: :any,                 arm64_big_sur:  "92642722fa0246448839ae7d939a9b5eacb4a9e1f521aac9562a180008796957"
    sha256 cellar: :any,                 ventura:        "6743f62f9ecb8cfd51f8dd9d7fca0dcb1faf32e19ee6cee1733f03d9a8eb7696"
    sha256 cellar: :any,                 monterey:       "730874ff1bc6bee968903fa68140b9be5750417f6c916e98f6197b6a803d3f62"
    sha256 cellar: :any,                 big_sur:        "40824202d1f6b8d5df16d160006316ba8bd0b9b2bd1078b1dfa0342cf40faf42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591606153c9e455795cca217bd8a6254c32ec7e4453d48f9952ce68344447c25"
  end

  depends_on "libkeccak"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    # Makefile requires GNU sed as of version 1.2.3
    # See https://codeberg.org/maandree/sha3sum/issues/1
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # GNU make builtin rules specify link flags in the wrong order
    # See https://codeberg.org/maandree/sha3sum/issues/2
    system "make", "--no-builtin-rules", "install", "PREFIX=#{prefix}"
    inreplace "test", "./", "#{bin}/"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "./test"
  end
end
