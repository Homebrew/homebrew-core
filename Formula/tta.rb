class Tta < Formula
  desc "Lossless audio codec"
  homepage "https://web.archive.org/web/20100131140204/true-audio.com/"
  url "https://downloads.sourceforge.net/project/tta/tta/libtta/libtta-2.2.tar.gz"
  sha256 "1723424d75b3cda907ff68abf727bb9bc0c23982ea8f91ed1cc045804c1435c4"
  license "LGPL-3.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libtta[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48fe3083c87c3f78c9ce5d2076ed9220a18d6ba64347e5b10e739d1a08c4fce0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941f70e3d5b3b0ad8846dbdd68e074fef2094e9e9ddde9494a781b045b1da3b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd5a172d4fc33058df72affc82f3b4d0f66d147007bce62e45b429370403fb29"
    sha256 cellar: :any_skip_relocation, ventura:        "2dab99ae6cc3568d3b685607cbfb8b624f916d8e2bceae530fb46656509298aa"
    sha256 cellar: :any_skip_relocation, monterey:       "21fb40ccded96b6a0b51ecf1c078ddeae5b9bb116d4ce88985d4bb5b93644aae"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f2b84e5f849d0903006aa3550ec718c31130b4d50271efef0ffe37c1a29e0d2"
    sha256 cellar: :any_skip_relocation, catalina:       "af41c210ceddaa4957dc8bc4fec9dedb839157914c3d2d9fbb4bed63239cd9f1"
    sha256 cellar: :any_skip_relocation, mojave:         "898e75423e5f2a1f872b7ce2e2258db686f09ea04edf56555b15c113f04e9141"
    sha256 cellar: :any_skip_relocation, high_sierra:    "10ec40111e20f5168d67b02c52b464065e72fa48060c37a5fd86907062e8a997"
    sha256 cellar: :any_skip_relocation, sierra:         "7a3c44b675bbaf81041c7eeacef622fab8fe3abbc83329a927a1ed0034231b1f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0543d1561fe44fc6137f90076d247f16e6ac28e72413a7ba3bac08d422bb4e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30808b3d8bf5450eb396ecbf102837b9943355ea54cb6b27c052b6e2fd902adc"
  end

  def install
    args = ["--disable-silent-rules"]
    args << "--enable-#{MacOS.version.requires_sse4? ? "sse4" : "sse2"}" if Hardware::CPU.intel?

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end
end
