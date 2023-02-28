class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "22654139ff2ee26b291976e5eeed7ba96990c624bec94446323022d65e0f8725"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c15834f0e34c6ef4f6b5f0cf5bf32c433afe86f8943b7fc9dbd4afab48467d11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fdeeba5ef4c70f6c1ac77d2036801746040a83cfe2df922d6a677b2bd42cdb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ef43faf922f37dc9e9e6877d49d62aa2fd35ac883cd2de5cfea12c4b2a8f6a4"
    sha256 cellar: :any_skip_relocation, ventura:        "d10e2c6c514606f612950a5acdb6dd97924203b3cd92ddbedd51e836c8c44f64"
    sha256 cellar: :any_skip_relocation, monterey:       "2ee43be842c071a873fa37f6eaaf5eb9f94755741bbb71fe26a259660ae8a818"
    sha256 cellar: :any_skip_relocation, big_sur:        "34171273ab4b9724f5b78e515c4ba755a010ae0bd057fec84e46254c5a24cde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6e95a2d6490750e9b3e42d784dde75d0f0c9f1a4cd08a114bb8bfe585be2c09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
