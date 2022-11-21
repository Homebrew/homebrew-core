class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.0.3/stgit-2.0.3.tar.gz"
  sha256 "3b6799fb87c6c21270af315cb3832798a761f96b3ca1720221242a3e8d6ef51b"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f92818a047bc7a37c337bd155d152e3827c877cedfefddd4e1e5c68d0778ff3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af61a689e7997145eb91c7f2287c0509f9b9fcb17ea9929046679fca1779dafd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "126302c379c4ff75ff0523b694139c59334b3ac377c607eec003445579de3044"
    sha256 cellar: :any_skip_relocation, monterey:       "d652a6b1f1a968fb810e5f1e4ab6b7c771e61d17865699c567f8b18ad6706c4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d0385b1b4d43d853fdb0d7322fd958f8b6dc9ba6d703a20a73b1df7c7a7814e"
    sha256 cellar: :any_skip_relocation, catalina:       "12362ed4b40389c55e477aa5f090512a2cd35b78db3f2e895dd834ba2e12de01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1117c29e57b70de4b5e374d658cbe69f76a884f738d377aac229b0446c2804"
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
