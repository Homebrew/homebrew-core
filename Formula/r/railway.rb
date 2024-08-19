class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "8e2e04c2408377d812cc27e2f82861e39418737a6934cb0889b7699324dcec65"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86bc3aadebd76ef87175c89519be5b57aa197a76757a3a9426196a7126a5af0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d12c85db53ed2ccbe04753bd541a0d562eac8c175760e2bba3e8f9b0a66e210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "226cefb4ec35a64a3abce4e1a1a76068affa71588160acd8f637ffd7d2290e0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa09052098d6afc022855ebf2b0823aa02e6d6ead470126004b521ada82cadc5"
    sha256 cellar: :any_skip_relocation, ventura:        "4de083927d96fb5c297a7f7672cbe8f596fd1269efdb4cbdc1ec9c77f785eb56"
    sha256 cellar: :any_skip_relocation, monterey:       "05c6d715fb11333bc70ddf5ec5dcab1f6fa55cc6e29aabf25db1996039199d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8604813e1993d04cc54691154b2eb8c0c14ea8d144138b0424656628922bb09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
