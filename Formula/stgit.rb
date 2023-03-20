class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.2.0/stgit-2.2.0.tar.gz"
  sha256 "9366a77f20ca02cd4ac1d520b9adafe4f16452d901d3dfa6cd9a59e10ffa20ae"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e129387f3c550e5e104823d897ecca99ddaf243e2118919ba521d3c126c55c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6692ddf2dacf561fb9566cee7a2e9bfdbf5cd95b1b9432eca27141d94f85883"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa1c8142780d5277f49a2759405945079bc37f70f237eafbfa75227db7423763"
    sha256 cellar: :any_skip_relocation, ventura:        "d1f59cccb1baf9d0e8ca4854c96712bc167ccc9157cd33d5e65157075fe88be9"
    sha256 cellar: :any_skip_relocation, monterey:       "f1684ceebec41a45bd6f6ffcbd48ded63e67cfab408f177a71f9e1f2712dec0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9782b653a9a7ac614c2d09274a78f87e1f41983d59296c29e19347e8ea6d1bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d09b7a11d1e2b179e5b445d0025d6e87d6cbd490117e10384587f4dc5b37cac"
  end

  depends_on "rust" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"stg", "completion")

    system "make", "-C", "contrib", "prefix=#{prefix}", "all"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
  end
end
