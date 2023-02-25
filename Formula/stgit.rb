class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.2.0/stgit-2.2.0.tar.gz"
  sha256 "9366a77f20ca02cd4ac1d520b9adafe4f16452d901d3dfa6cd9a59e10ffa20ae"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f514762e07e0ee889e099f8b864616f661fa3a737ecdbac433514d2db6fcfa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ab9d72c615aef78f972c6a7c653c40e2dd538291fffd2309ee2d36b79d62b54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8acf4dcbb3917f260cf4d4a1d63d588b37cd93d0eac07695bd851c9f52d0aa9"
    sha256 cellar: :any_skip_relocation, ventura:        "31bce858de5a3dae0f1e7e7665fc11f08d712c8d47f16fb786fd2935a2f08492"
    sha256 cellar: :any_skip_relocation, monterey:       "91eaa7a5fcffd9c0404fa25ec28112fb708058b459844c28bee49643c30b61f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "13f83bed88d1e54b32129ff0eb7e368700402fbc1fdee39068e0051d8799e37c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad32b0f2133a1bba7635185b2957727b21537bff10c893318f648e719de1c8b3"
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
