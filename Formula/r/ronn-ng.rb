class RonnNg < Formula
  desc "Build man pages from Markdown"
  homepage "https://github.com/apjanke/ronn-ng"
  url "https://github.com/apjanke/ronn-ng/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "180f18015ce01be1d10c24e13414134363d56f9efb741fda460358bb67d96684"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d1331b7762f2c22aa293706c8bf47a61dfdf219478c277f5dec6d5c2fce9a44"
    sha256 cellar: :any,                 arm64_sequoia: "0734fb103f97545655590bd5778f7c4c64a984d7ef200580f6ac306cb7dbec23"
    sha256 cellar: :any,                 arm64_sonoma:  "9b09b583821984dd3b095fd8762d84de2a6a95a66b1bfce30e3ec765031e5b53"
    sha256 cellar: :any,                 sonoma:        "a38e92d2f695af08219c18c263275f1ec162588dbf17a41f4d374858cb435a1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a0040cdec456e90c21efae66d299b5a18650ee4eda8c9ff5a35e2bee4d1146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb2b1badb882a826f007c77a793d8ca6f7099c30843e9681766a964f6464367"
  end

  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "zlib"

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
