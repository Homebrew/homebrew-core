class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.57.1.tar.gz"
  sha256 "027a478782d9ee4d27e8ff19cca5cd664375401ea01ab3a1fef2160919f8a3db"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e11b13c4a68aa541191ed1b14a2787f2ae97590b9c33c45c80b5ebc66cfe678c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f00dc466a89f91b754ee1293d65e9d083f9964b536b3f7e0b407d2da409034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "979e4efaed1cde3b0594f66556a84ac14832b5a5f3804aaf180a4582f3a7aa9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f62b650e551663ddaf12e376261cd1e72c002dc72d2a5651c2dbf8246855c595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b6b097dbcf8a445687a135b3496df80574c0f0e2d7a5400500c68628aa54d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e470db632cb3c386dddbfd8627922efb8932cd1897ccde4201339e90419ea10"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(features: "parquet")
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
