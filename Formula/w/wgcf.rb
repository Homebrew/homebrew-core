class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.32.tar.gz"
  sha256 "1cbd077422b108c1cca1a7083ef759177512b6180e33cdfaf7d8c9422783194c"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "009a7a98a684353ba4a0b7e19dfc05bcd562701bdc4a5a3113b067ab7a6a8a7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "009a7a98a684353ba4a0b7e19dfc05bcd562701bdc4a5a3113b067ab7a6a8a7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "009a7a98a684353ba4a0b7e19dfc05bcd562701bdc4a5a3113b067ab7a6a8a7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d5e34482785067fa2f0239daafe8adfb318f574f62296a72d9604ac441c056a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afe95380cb462b280de1546e9d46cb4cc3d942a7601a7a39ae88a6d1cccbcf73"
    sha256 cellar: :any,                 x86_64_linux:  "23dcf3ce534408c0d9db48c41732a96ac4704eb7f72e9f8a75ecda2b44171c4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"wgcf", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wgcf", "trace"
  end
end
