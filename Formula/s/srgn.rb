class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.11.0.tar.gz"
  sha256 "82b0fe9282293ce2a132769e0ad4640d531c08d43b23798e2a51ec917a89853c"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9502974bda8a829cd0f02a488e920aebf220b2b730ae3b3f9139bec6336e9c7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c39e18f77523336c1bb8fc05aeb14c2c730731278474ad1146d826758b7cec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fd6c628f68d4b9c134e65570c15bf10f7713ee6da12ae88ef2dfa213676f4ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d13fb260523de7976895358288c7ba0874d682d1bd087cecc1c14bc290cea91"
    sha256 cellar: :any_skip_relocation, ventura:        "2fa8f93f0dab332c957d4cde998c5e09ad207b665c72cc53d0cab48cd3dc3f22"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a36b438b7f3e3ff86ab6689bc8aca99562d5032ca208d324f2c0bccf8be215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c815fb0a60589747ffd43c0c3242eb5e74079ade72f0dddae0cd99aa44e24159"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide ******** and ********", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
