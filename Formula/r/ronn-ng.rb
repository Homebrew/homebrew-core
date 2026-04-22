class RonnNg < Formula
  desc "Build man pages from Markdown"
  homepage "https://github.com/apjanke/ronn-ng"
  url "https://github.com/apjanke/ronn-ng/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "180f18015ce01be1d10c24e13414134363d56f9efb741fda460358bb67d96684"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cde2a1921cd09603374d28ee44d9c470f0b187add7b9d9eb0b526d7dbe5a3305"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cde2a1921cd09603374d28ee44d9c470f0b187add7b9d9eb0b526d7dbe5a3305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde2a1921cd09603374d28ee44d9c470f0b187add7b9d9eb0b526d7dbe5a3305"
    sha256 cellar: :any_skip_relocation, sonoma:        "e81143c3c8d224765b7db5c39a07caa7c2d7d2c9a291064f99186a1b6a7578d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43cce7ff99b681bb070ad22d1b9ee17a4c2093c79921cd5211095242a05222a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4fd9f3b447f24382a9d97e7a1aa2cfdda53eed5ad75f19b0e6d2ae6e210938e"
  end

  depends_on "ruby"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "ronn", because: "both install `ronn` binaries"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "ronn-ng.gemspec"
    system "gem", "install", "ronn-ng-#{version}.gem"
    bin.install libexec/"bin/ronn"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    bash_completion.install "completion/bash/ronn"
    zsh_completion.install "completion/zsh/_ronn"
    man1.install Dir["man/*.1"]
    man7.install Dir["man/*.7"]
  end

  test do
    (testpath/"test.ronn").write <<~MARKDOWN
      helloworld
      ==========

      Hello, world!
    MARKDOWN

    assert_match "Hello, world", shell_output("#{bin}/ronn --roff --pipe test.ronn")
  end
end
