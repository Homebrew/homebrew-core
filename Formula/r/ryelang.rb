class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.80.tar.gz"
  sha256 "542459a96ef929164899fd20dd31677426bfdd2886017539988fc4ab3cec7165"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6892fcf8630b7746c9478c7f1d85509901504f449be97d4bea9d4cbdb7271f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7a347ba65ed5acd1abf47fbf75124ae80203446af59ad07e43940d5d58b24b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0aa6f187d237eb149dfc5a19885c1762d5c7cb96f88822daa755516c621faa05"
    sha256 cellar: :any_skip_relocation, sonoma:        "074d1b4c5249fd6b578918bdd0bac6339357188270acef16b4b6bbb319849699"
    sha256 cellar: :any_skip_relocation, ventura:       "50d2b89b3b4250fb5b8ba15af3ed2ebd6a321b78debbd749fd44472139ac0c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea279ea25b8bac4d4c748a6dd550c0c69bfb0c781718fd5c8f02355e11aa2c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0f3d92e4e463e223f2100979fbc31ae705848a052cfee2050a007f393bb4aa"
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
