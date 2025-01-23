class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "58f1998c7d03daa30aea7a29c57893c87399d1d722dc5d2349ad3b4f7dc599bc"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5510040b64f0a9cf2d310a27e0c1a82b3eb130e89774f685983352d6cd1974fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f226e3ccae486d4c57366a9254fb58143b105d3f8cff38128eccad8931d8ef27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d8df45e31f040c10abe32e453752a8936f8b243f55f055acf5f13901c8a63b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3d8349c104fda7ea2f942bc7cd78ad0a9a51e3f6993ecbe0864e79e89761a74"
    sha256 cellar: :any_skip_relocation, ventura:       "24f04b4289b7c9e33d87dafd6fe1a50f6d7eb74793af7b5ab632bf135b8c8531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58d850ad1c83658290b87b0399b221f6d8c6bb6080de122f52cc06f4df29ba9"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
