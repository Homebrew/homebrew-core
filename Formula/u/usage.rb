class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "f42a5d1956b408202ed28c51cda9bd2905c500beb4a2322967dab40961673a2b"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c7336ea7efd4664c55b91a9318d1be4ae1b299c17a7fa4542927d0275a7a9ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17fd231bbecb699853d38b202bf957b51d435b991dd3a6f74cfcaf234eb2a46f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bef97ffad16a617e740bc49824c43ad182b31dddd1b682ac6df4942ec6e560c"
    sha256 cellar: :any_skip_relocation, sonoma:        "092e22ab72e31fdf118cb1e7f4f2417b6f7faf74bf109c4817ced7f338e0c371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95af3d5e4cf346386966525d6ed573cf3d1fa04a742e93ba218fd92565caaed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6905c5aa2e651b49d9dc9d5ddedf514436e76a434b26cd1edd18861ee1a0d077"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
