class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.0.2/stgit-2.0.2.tar.gz"
  sha256 "17c9afadb4a652e0ed0a806c5618b1ba74c755f26d29d625ebfbebd9de3ea996"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e936b86e6a4ed0b15a935c4ad388a54ac1f792d4569cf82fc78682a086d8cb8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb67c048bc739e2829ca71f243fd9d46d6a62464631a38c4a9d97f469009f4f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31c89288c24bbb446a3661dc5174e0a85732e48ad9356ba71ad56312a7470389"
    sha256 cellar: :any_skip_relocation, monterey:       "d34298e775ce1b2a7d5356d4c90951f49c84e1620393a301be52063b03810cfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "05d6535420a3b89c175488eadfdda7e681e24d1c89eb07563518096c85be379a"
    sha256 cellar: :any_skip_relocation, catalina:       "26239c10c92e0fe07e2bf52dd29f1181e84f150f53def944f65295b9a6751d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec8c5faedea3618457ddf11f781688751964e3607f2422391644ce76e428fe9"
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
