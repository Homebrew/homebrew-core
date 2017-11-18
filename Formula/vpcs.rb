class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "https://vpcs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vpcs/0.8/vpcs-0.8-src.tbz"
  sha256 "dca602d0571ba852c916632c4c0060aa9557dd744059c0f7368860cfa8b3c993"

  bottle do
    cellar :any_skip_relocation
    sha256 "99433e0f18aa11f637b9cfa854bdf38a5754292477db27847419b1c6fcd9c6cc" => :high_sierra
    sha256 "c98123da9a4158f1b9c2cb7757f553e172adf64f106028af07aee50e9d4e9111" => :sierra
    sha256 "b0f62e8959cb98038b817174eec35dd657a8107241f58fc1421a57adcb1eedea" => :el_capitan
    sha256 "d905fc7dd6ca0dd07a0bafb6d8e71bebd0d2c3c516c0c00f6adb87aebf6d7057" => :yosemite
    sha256 "a6a5285281f81b0f035b024f0f8e81211ac71f69390c5c6d03820ce7eccdc116" => :mavericks
    sha256 "713bc04995e9cbe4cafc759643035b0b34431c5c3e559ff60ede0e674cfe4538" => :mountain_lion
  end

  def install
    cd "src" do
      system "make", "-f", "Makefile.osx"
      bin.install "vpcs"
    end
  end

  test do
    system "#{bin}/vpcs", "--version"
  end
end
