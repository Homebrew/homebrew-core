class Vsd < Formula
  desc "Download video streams over HTTP, DASH (.mpd), and HLS (.m3u8)"
  homepage "https://github.com/clitic/vsd"
  url "https://github.com/clitic/vsd/archive/refs/tags/vsd-0.4.3.tar.gz"
  sha256 "a50a7e749693dc38c48d8ea64178da8c513895f381f6c8a2516925c7442a7bfc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6afb8eff7a7b62ee6b5c4d500f621c407afa66bf212fa4397fe8af7aa4ee87f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8abaffcc19f3666772c38792b46a2371e945e0eaf5941ebbaa754437d39f318c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5da1799a9df3a4d1e053aa31986682cc986327c729a4df782a4d7cecd9c62f47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3f732f0b2d6b00d959aa08289ee2f1c4a98ed5c397796034d27c11a291fd116"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a583dc975ea90844e8fa056cdcbccd99584fee50e59ae00d663cc4173457cb7"
    sha256 cellar: :any_skip_relocation, ventura:       "29d474e46b2c8a02689e43515f647a85782a9047ce1806722ee71a904092ed2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9eb0ce725f4b3592b446e05387e2a5f159c4b1e3c2223154093843cfeb18169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51be065f05066ab65664c99440369eeee9b629919fd635bef1e169849f0ce720"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    inreplace "vsd/Cargo.toml" do |s|
      s.gsub! ", path = \"../mp4decrypt\"", ""
      s.gsub! ", path = \"../vsd-mp4\"", ""
    end

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
