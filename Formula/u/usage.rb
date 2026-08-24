class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "5f587fdaf34fe52b6613a91bb8212da2b99cd8f7dbeaac4bc1628a168bd20bd9"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76bf1523d960effdceda19a3f4336294b397008883ebc7bab300ecf8f9da3816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd912cd5488af90f2a04eca9fd9ab9d78ba595b9865edbc4fbee35a27f184358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45bb177a565ceb5231e21fbaf0f9f75ab4c647fd3d69bdca736a7a2e2688d34a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dd8f206a837f6cefa84301a326034e214bda53532a62c56437c71f4fc09e5f2"
    sha256 cellar: :any,                 arm64_linux:   "f1b1e781bbbd80e193bc4fa6360cd7d1bb51c6262c7590fc3452817b99938ed5"
    sha256 cellar: :any,                 x86_64_linux:  "e6095adcf36b5bec4c72b51166a4f138d0a3b06fcdab28a0c6f3283151a73a1f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
