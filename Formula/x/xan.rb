class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.52.0.tar.gz"
  sha256 "da4ee61b829284948841f88a7ce01078067aae29f0965311f0c4632467ff8721"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1246746dae0ab6db7460cdbeec016bff903eaef4e9fb5cd06acb1ec74dbf386f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c5ca5bacb95cf74f415e4b43d30eea08be880c7e0b7258f1fe4ec48657b0de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a2bd365b4a9f10ca7cf88cd976d642575a52b1d0e8d3f356c208d0985abcc19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "052b14c1bbca1ab59fd22598d2f49d3b96fa0a6b57f0bba955f9543107e5eab2"
    sha256 cellar: :any_skip_relocation, sonoma:        "85dcffadafe0891274409c80b07292f799daab579d78e05528bb9dc978924f79"
    sha256 cellar: :any_skip_relocation, ventura:       "3513118aff96ba332bd837da44cacf0f8f9c3375b08713fe154556b0ac91d905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd32abffbcf73bdc9698e9b26886508e332422d84c938c2966286451497df8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c94591f1eff98c8439dc5da14af51f3b5a45248f91a01f67de3058d5673e3eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
