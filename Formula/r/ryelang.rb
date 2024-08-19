class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "9cfdd55a027f2399d5a38e26f6766689e692476016c773ce0e5b2f2378dc18e8"
  license "Apache-2.0"
  head "https://github.com/refaktor/rye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6a08a33a921b461e93bc12e8c266405dfde8e23fe80ce576b0053ab1af3d326"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b5ec1deed70a606e3c8344b01c9e8db03832672b6e9fd4def35411f2060d774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68752101d3a52ec8ecb47fd120f5f88ec57e0bd081e047adec29b19d16b8fdbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3b692f6571f5fd4ca8bbc73ab8c913b22fa8aed469add801be09554da79c6fb"
    sha256 cellar: :any_skip_relocation, ventura:        "540daae8d42a6410ee0905e18a3077c2c4a2f6b4d02153c59eb3eeaef617d7d1"
    sha256 cellar: :any_skip_relocation, monterey:       "27d04e6b26793d9fbb7f98364b668eed270ae5be5d98e36c390bf68db1db0f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b9f0644b946267ee9983dc135cb91d71997faa290f22138abe715fded19781"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath/"hello.rye", :exist?
    output = shell_output("#{bin}/ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
