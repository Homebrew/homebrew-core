class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.57.0.tar.gz"
  sha256 "8931f7a8c48d79cea5c217ff771558ef9e7b5ceb1c802486164624ac681ee588"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "865f220f236cca9188de5739e5ce5913792245c7721838d77bd165b73c4c23ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7929bc3ba42a6c7c401b395558843304a582ad37826670903038a6eceb892d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b688c95c89623ff41a65c4e8bff6d2deb03094df4d268ae0c7709f0f5ab2ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "7434d21a0acdb6951d6410f3668b622e022c20ee0d639dfafb7c7a6b7ab6cce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd947c11fb04144b8f682cd08cc4a2f0423e63c8be5c15d954d421dba67f0ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec9d76dd35da691bf18f913630c6c8f7e068cfe680d8a43e0ac4261b307d3ab"
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
