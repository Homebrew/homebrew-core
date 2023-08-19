class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.3.1/stgit-2.3.1.tar.gz"
  sha256 "edf590f9ffaea1c235aec11c411cee12486f354b3235fa9e84bec26e735f997c"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e59422279e47bb2c8e5588fcd3c4a5bad9233b962d43cbd282178bfa2b611d73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "196d21bd030bebbd02d0befa148fb0a291309a5e21206c25ac8ded5d76a424d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca1029ca82063955c2deaffc9a5a9acc6d319b410ca176a4e0cfb4d316715ee0"
    sha256 cellar: :any_skip_relocation, ventura:        "1864ebccbfeda15d42bcab878d86239ea7b65b2023e763b7cda7ec5cd21f8055"
    sha256 cellar: :any_skip_relocation, monterey:       "736d2826f52a65411fc4c80536d71abf9150f9f5b10eed5ff25f017755cf2224"
    sha256 cellar: :any_skip_relocation, big_sur:        "f77fee3ab160b6b00e157dea4fc814fbfba27ae60679d730876540a4278c8ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a1f37b5afcc59ece49f8a13edeb037eb16a11368346d9b5ab0d6ec07041f5a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
