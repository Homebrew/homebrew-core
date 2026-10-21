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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82282a8a17513fd8dd7de2cca44ef495c051d5ad10ca06974175b49fadf7977c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71fc506abfabffb5b25a1441bccec05b942cd736ff268e79dc68bbcd2d0a4717"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc6bde619cb080f8df0a85eaf7c1be6c7b8bbc44a5d5c318dfc1f7e30c6f7959"
    sha256 cellar: :any,                 arm64_linux:       "6f680b091539c063342f794ded64c17bffd726d9819e18036365cf25b02fc615"
    sha256 cellar: :any,                 x86_64_linux:      "66f0d6658d754d2805eb2f6abf1f217a6553fe9f994e5ff743bf9984c87237fc"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

    # Replace rustls + aws-lc with our preferred native TLS backend
    features = %w[capture license native-tls]

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "vsd", features:)
  end

  test do
    test_url = "http://maitv-vod.lab.eyevinn.technology/VINN.mp4/master.m3u8"
    output = testpath/"sample.mp4"

    system bin/"vsd", "save", test_url, "-o", output
    assert_path_exists output
    assert_operator output.size, :>, 0
  end
end
