class Vsd < Formula
  desc "Download video streams over HTTP, DASH (.mpd), and HLS (.m3u8)"
  homepage "https://clitic.github.io/vsd/"
  url "https://github.com/clitic/vsd/archive/refs/tags/vsd-0.5.0.tar.gz"
  sha256 "d47092ce89c22d36d0fd976bd558fa9f895384025cb98e568adbf9793134d7dc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2824d1545037a038493c3ea5dc2ef33d168793e55c256ad165e5ace9892f34ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f420d304a245d8d8ec270f04f7071eea800f65661bf1e905b8fd67da1c7c25e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cac2b1c8306daf6220a6ef4e1791d1d9308cf18cce7eb308151f9809181ae4de"
    sha256 cellar: :any_skip_relocation, sonoma:        "26e2ab4d646c354ca91cd73e8012eefb3fa5032ac80e2f3aae9fc1de8b5fa64b"
    sha256 cellar: :any,                 arm64_linux:   "e881b922206a2cb5a53ac4cd339618f4fe989357032e7aa634e05cc2d9dfd150"
    sha256 cellar: :any,                 x86_64_linux:  "9cf551ab8f7248233379b7bd4245de341380deb146e780d207c579b8c0271517"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    inreplace "vsd/Cargo.toml", ", path = \"../vsd-mp4\"", ""

    system "cargo", "install", *std_cargo_args(path: "vsd")
  end

  test do
    test_url = "http://maitv-vod.lab.eyevinn.technology/VINN.mp4/master.m3u8"
    output = testpath/"sample.mp4"

    system bin/"vsd", "save", test_url, "-o", output
    assert_path_exists output
    assert_operator output.size, :>, 0
  end
end
