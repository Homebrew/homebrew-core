class Seqtk < Formula
  desc "Toolkit for processing sequences in FASTA/Q formats"
  homepage "https://github.com/lh3/seqtk"
  url "https://github.com/lh3/seqtk/archive/v1.3.tar.gz"
  sha256 "5a1687d65690f2f7fa3f998d47c3c5037e792f17ce119dab52fff3cfdca1e563"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6cf3d61b32d87a06c5f10459779e4d8694cdac21a315654c447bc56ed3f4e00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f31a109971c3906efdec050e77ae151e16f3c54410d3b9ee4b229839b610eb0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e1d4c35dc64c5ea008ecb2e83bfc5d7a4047256e37923a981e5a6cd6038f368"
    sha256 cellar: :any_skip_relocation, ventura:        "3afddde22ed6a5e2cb5c49389ea6894c758624f34ca09e64430a14385293085e"
    sha256 cellar: :any_skip_relocation, monterey:       "b9b943a7ee965c28916f2db8dd49e734022e74a5fce1e78af2fef017649c9b72"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdcc9b85644f98bbcdffbb84816e40714c254f8e9e8c8e5c042b4d25496e0010"
    sha256 cellar: :any_skip_relocation, catalina:       "5abbf374f3dab69b198b98a3126f521b64baf01ac5ed69b99be91ffd97f891f8"
    sha256 cellar: :any_skip_relocation, mojave:         "b695a43103700d7d0d4a07d50d8effec280f7d7a781ff518a42dec2bef44801e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4f377caf93e5d334e739375a5dcf06782f1d85516988a26df3f8f53d172b1e6f"
    sha256 cellar: :any_skip_relocation, sierra:         "fd3ecced5ba8f5a9eab13f8f2184f6a69d08b58c1ef53ad6e74bb45cab9324f4"
    sha256 cellar: :any_skip_relocation, el_capitan:     "55541e7e9249ef15bd4423ad9a45903918c2b4b54f632bc0472fb24aee683701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9725834121170e1a61b42865512da270435a30ef49f95ff070179baabd655717"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "seqtk"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      CTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_match "TCTCTG", shell_output("#{bin}/seqtk seq test.fasta")
  end
end
