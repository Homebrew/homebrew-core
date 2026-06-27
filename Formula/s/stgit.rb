class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v2.6.1/stgit-2.6.1.tar.gz"
  sha256 "45e6db343bac075ae898d3e8616565804c917545d9be45273ddc8f0666133147"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae2ec198a48251325dc21c316971b34858fa9175a44edb759eeccc1e7a8756a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5ace2385a4dd49075d852bb751569f2f5dd580cc9d3a5bc5ad3750e7623be38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3e448f9f286a7a28d8cd3b0b42d2bd3385762696b717fd70bb821f628b64a2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e837974ac8f1d336314a516592e546213997595e21a9ff972b569ad3e92811a"
    sha256 cellar: :any,                 arm64_linux:   "0a8558270df53fcb8e76b2427b0c23f220d72b7889d99f5a1f0ea715577e44a0"
    sha256 cellar: :any,                 x86_64_linux:  "bfc046e095a326ab0c24f50c326acdb9bff03fc3c63881eab5a09587f7066b41"
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build

  uses_from_macos "curl"
  uses_from_macos "git" # needs git >= 2.2.0. Consider using system git on Linux once RHEL 7 ELS ends

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
    system bin/"stg", "--version"
    system bin/"stg", "init"
    system bin/"stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system bin/"stg", "refresh"
    system bin/"stg", "log"
    system "man", man/"man1/stg.1"
  end
end
