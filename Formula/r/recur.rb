class Recur < Formula
  desc "Retry a command with exponential backoff and jitter"
  homepage "https://github.com/dbohdan/recur"
  url "https://github.com/dbohdan/recur/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "e1237455a14cc2b5c6a36f93b42b7fe98f24a0aad22cda7d7c7f29d83fbb261f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a33e3ccef88d17965f1b1ddbd2cbb25cc439c7cc0aa65990f5d4ef7d39b83bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a33e3ccef88d17965f1b1ddbd2cbb25cc439c7cc0aa65990f5d4ef7d39b83bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a33e3ccef88d17965f1b1ddbd2cbb25cc439c7cc0aa65990f5d4ef7d39b83bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "79cfd6abdfc9fbf499665f5674f45355701c62caf76096bf5fa46f1b297c4a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4cb2a8e43655dcdd038353d9f9bcbccf7cec6117a4b543dfa68f58e7e36e1b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80fc99124b1d694bf3363983fc8dfd3502f15fc287b34328136945c0e947fb9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/recur -c 'attempt == 3' sh -c 'echo $RECUR_ATTEMPT'")
    assert_equal "1\n2\n3\n", output
  end
end
