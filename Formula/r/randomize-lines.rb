class RandomizeLines < Formula
  desc "Reads and randomize lines from a file (or STDIN)"
  homepage "https://arthurdejong.org/rl/"
  url "https://arthurdejong.org/rl/rl-0.2.7.tar.gz"
  sha256 "1cfca23d6a14acd190c5a6261923757d20cb94861c9b2066991ec7a7cae33bc8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "54390ca4a64d2cc044e4a562f868476d9821274a86758db0fd035079fe9e5db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8ec08636ac3e5aa68060b1f43a1bd6a5cad418f489a4bbc9b9554053aa06188e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "194a2a869a8ecdeab95baf1f6b5f9d5d13c12eba7b6acd1378817da3e01a9740"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c351e68f794607d01893bca67180a80b721b597260304eb258f3108227950f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa2233b5cb7b9dd6ca98f51a6afee212967af3a1dd5b5d27f4ef0a7359c7bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c107eea0fba80096a370db46e622320bdb9ea825b837280e46ad236b3a37bbd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "10e538eab3c969a0253e4febea9ce1d45b015e7b388c31a818438f850cbb5144"
    sha256 cellar: :any_skip_relocation, ventura:        "489084bd61495369766199746c6a3f011fe598d5b17eb809c10e99c9cfec7526"
    sha256 cellar: :any_skip_relocation, monterey:       "7dd7d179e5ac4567f69860ca54a379be5424a0c5e6fd8f0088ce6c158a77c47f"
    sha256 cellar: :any_skip_relocation, big_sur:        "05b5f772ee8d86ef341e30e91194b0a4b0cdbe5d3e16c8e319ed5e74a901e806"
    sha256 cellar: :any_skip_relocation, catalina:       "ff6262e5a351158ca8a2b25b577a892fc4cf2b7f9a2330e9fec595970c81674d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "764e49f56b35776d575f1c96474373185c667956751c0c3b829680038a32e9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d3ca6029fbd900632e5f09b68c583b1f441cf1bb711041ab00d519ee8fd323a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      1
      2
      4
    EOS

    system bin/"rl", "-c", "1", testpath/"test.txt"
  end
end
