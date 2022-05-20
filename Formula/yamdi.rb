class Yamdi < Formula
  desc "Add metadata to Flash video"
  homepage "https://yamdi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz"
  sha256 "4a6630f27f6c22bcd95982bf3357747d19f40bd98297a569e9c77468b756f715"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6796b10d1af7ae38ed559313b5646047cb1456c66428d9c32f5e3a0981f1f4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "375c99c3793fe45e70a76ef708f9d1b8d5f4e9a7c7f64eca0f7f522926432d82"
    sha256 cellar: :any_skip_relocation, catalina:      "6a3483a957ef3a480f5391d9483b0d3cf8adfce2ec2f6b48289f16733ce29771"
    sha256 cellar: :any_skip_relocation, mojave:        "228b23059d21ed0a540d3b19c87f3319bb8f99ff57465b8b313d2063660a8567"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1c524b6c2d791792b27d15941ecd179b487fbdcd299640f06cbf17bd5f8cf434"
    sha256 cellar: :any_skip_relocation, sierra:        "546a4c5400ef75431ecd3a39dbabda5e5599d82ac3f65f6dafc5d3745a90d8e2"
    sha256 cellar: :any_skip_relocation, el_capitan:    "cfaf451a985b0a8cba24a0131c8e0e9a6102eb4b6c315e045ce258999cb19494"
    sha256 cellar: :any_skip_relocation, yosemite:      "7041c6dcf877e8e003e2acae68a75ae6a461e92df63fde374157884b52cf2d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a7cf29beb52e599c9d245d550d00848b935a8d8e5c0b9f3d46fd362e28a32b"
  end

  def install
    system ENV.cc, "yamdi.c", "-o", "yamdi", *ENV.cflags.to_s.split
    bin.install "yamdi"
    man1.install "man1/yamdi.1"
  end
end
