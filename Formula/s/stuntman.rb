class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "https://www.stunprotocol.org"
  url "https://www.stunprotocol.org/stunserver-1.2.16.tgz"
  sha256 "4479e1ae070651dfc4836a998267c7ac2fba4f011abcfdca3b8ccd7736d4fd26"
  license "Apache-2.0"
  head "https://github.com/jselbie/stunserver.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?stunserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "905f59c8b80028188a9eee9f31b21b77408f3f76cda7fdc5050b193d59ee41c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0042f42b8ca89bfd977af684226d49639dc9036d4b7b52eaa6b742b13e0bd37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "932c178c5aafbe6316b3fad54ab5c25bf08283358f79bcaa9c77a8c81cbe4d81"
    sha256 cellar: :any_skip_relocation, sonoma:        "f42e25761bca538a565590a6dd588518f30c35e0dcde6add737d19b466efb8b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97eee07cc68cdbd662a887d947a325e8abd00dce0f3b2ff83c52680358ae1a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7830bd81b31a5409326cbc83a60140ada145e197571916ab7193d7a48acb3aee"
  end

  depends_on "boost" => :build

  # on macOS, stuntman uses CommonCrypt
  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV.cxx11

    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system bin/"stuntestcode"
  end
end
