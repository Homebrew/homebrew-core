class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.54.1.tar.gz"
  sha256 "e5fa8eef2d2eb016b1c1d39a0eb2c4ac7d451cd9f4172ade99e1eb2d52ebd381"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1993efb2af79f2df1734e8eeb6640709e91a181fa924aa94f32fd2368a86fbca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03150bae4988f23aff800211b0398cc93f45c3a2a351467341fc50218ce9e9ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724672184ac7eb091a41150f7498e5edc02268eccd08b7f15ddaaf95a4c0feb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "dab64d4eadafb32783c8a61567b9fa0f088aeacb8092bb3e9efa4a54e54edaca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8755ed2089837012ee13359b08436eea62b25adf43ee4a3119b506f04a86e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301e76b17aa6f6858517c0145f5fe134ef90f15073638c9ea2ad97217295cd31"
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
