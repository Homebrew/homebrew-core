class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.4.6/stgit-2.4.6.tar.gz"
  sha256 "df3b6b11850785e8a1ac66d7799f4dd28a88b659808d58b7c78ebea98a2ca7f8"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6409ba1ae7d2be843025bb0e48c4ac3aa016cdcaca36334c785c2f5efd4aa1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f4f7b0a115b563056cbd17fdcc37fbdcc9a4d6fdc97bd1f9c18a7be0793db81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa116c4c56bdf92eaa2b572636b354616745ebf7cc37e21c9114c722b6f4f183"
    sha256 cellar: :any_skip_relocation, sonoma:         "012f79e7121f382235e64a8f2eff49d3fdd0a5eb11333728110e37756f9480fa"
    sha256 cellar: :any_skip_relocation, ventura:        "183b10d383cedb092cdad08e6b3c2d388126d1cb8009694ef7f4f6cd19208038"
    sha256 cellar: :any_skip_relocation, monterey:       "aac76048abd8fe15f3faf2f5777d0c0c98dda35f6b811e375b9ce97d5f306832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf8a5ffe490b9b861c0e8beb18ec1bf3bec67685f4fe922123493c0fd8b95fc4"
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "prefix=#{prefix}", "install-bin", "install-man"
    system "make", "prefix=#{prefix}", "-C", "contrib/vim", "install"
    generate_completions_from_executable(bin/"stg", "completion")
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
    system "man", "#{man}/man1/stg.1"
  end
end
