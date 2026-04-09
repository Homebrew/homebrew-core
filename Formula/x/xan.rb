class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.57.0.tar.gz"
  sha256 "8931f7a8c48d79cea5c217ff771558ef9e7b5ceb1c802486164624ac681ee588"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f8de1797ed653ee41309f370c5f2c5a6a62df10796801164f3d79fcc484a411"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90c22ab09db15cc2829f485e9ea03534b03048f241503d62a39a6caabb66e08e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a6093ff15cbeaa352f33800f54101bf6881af2611d0b1538019198f3c7e8536"
    sha256 cellar: :any_skip_relocation, sonoma:        "c88839894290c8134e1b5737b073a93a976b6041fbf76e01557c52535739fe9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db7016f01411f7e1e17c34accb106f3fb4f2730870ef0d2c92efa723e25f0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0597bea9c78d438b6cf82a97f09ca22f37c7fc686906f2d5a86eb428d55bc64"
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
