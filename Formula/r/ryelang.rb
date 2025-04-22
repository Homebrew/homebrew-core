class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.81.tar.gz"
  sha256 "95e0d9b747f44c216cd084574e1d7ab83428e6d84c3baba3aee0133a5988e8a7"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d2125c9c66434952160e27ecf528d440a0d916b71312cb49d376cdb81c2075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f3dc815c57095bcf44d0479504bd0e63221b2684a8ad67f0d994185e95f38ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00f5fc3284844f5139c02582d0fbb79df96d2af17d32ce2c6a61f88d04bca4e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "88e8e6122adfd577331f40b7c1334b159bf7112dcf6370a241f496e8e9c73ddd"
    sha256 cellar: :any_skip_relocation, ventura:       "1c06052b314d8dcc0c622d2d8670ace0b3810c4b5fbd4f626ca91028fdff1832"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c83eea241f5ec4bb0e773d157c1753765b6229644784bf3bb34072c3b12ac54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acc4baedb89004e858550b8ba09c44d8c6d2d8f86f8a1f1f8a992ec3a28fee6a"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
