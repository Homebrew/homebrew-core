class Seqwish < Formula
  desc "Alignment to variation graph inducer"
  homepage "https://github.com/pangenome/seqwish"
  url "https://github.com/pangenome/seqwish/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "90d1525c14d6003ff2e498f29b8cca31e947216536230908a6078d54b840372c"
  license "MIT"
  head "https://github.com/pangenome/seqwish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1178a7c1c1aaa90a647ddeec643cbd59d41628c6f7d2c407fad512dcabbfb25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a14099bc0cd618cd905a81cbd70f4ffaa179e343a4e99a9bc7f56e4936d895c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775fd23350c8addf83e8f2f07ed644070333bf2b612999090232729afecb12cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "848f07fe49c0e1d07ed97a27b471fd685bfdb48ce5b0fe4a84b6f7e921fee684"
    sha256 cellar: :any,                 arm64_linux:   "6492f18394ad0c47c78a3f980ea818c5bc794e976995344299da621ed9cd0ee7"
    sha256 cellar: :any,                 x86_64_linux:  "9d54e8b41291c568e507623677cbc420f94971126d3aa4aa1f47ee330224e145"
  end

  depends_on "rust" => :build

  def install
    # Upstream builds for the host CPU, which is not portable.
    rm ".cargo/config.toml"

    # The version is baked in from `git describe`, which is unavailable
    # when building from the release tarball.
    ENV["SEQWISH_GIT_VERSION"] = "v#{version}"

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"x.fa").write <<~FASTA
      >a
      GATTACAGATTACAGATTACA
      >b
      GATTACAGATTACAGATTACA
    FASTA
    (testpath/"x.paf").write <<~PAF
      a\t21\t0\t21\t+\tb\t21\t0\t21\t21\t21\t60\tcg:Z:21M
    PAF

    system bin/"seqwish", "-s", "x.fa", "-p", "x.paf", "-g", "x.gfa"

    gfa = (testpath/"x.gfa").read
    assert_match "S\t1\tGATTACAGATTACAGATTACA", gfa
    assert_match "P\ta\t1+", gfa
    assert_match "P\tb\t1+", gfa

    assert_match version.to_s, shell_output("#{bin}/seqwish --version 2>&1")
  end
end
