class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.10/reposurgeon-5.10.tar.gz"
  sha256 "f001d1e2b9c54797f9a3f84fb5d55ef9113a53c645d7bdb617a2ac1de3bb0ed5"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc0b75a2b5a6e6e620822b0b191e1884dff2504735ba2eb94a52066295c59a05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cfa8048d524af5e6cbebbfe459f5de72c47e455ff071726c776549f91e12bdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a898d756eafc9a08d14ef94099f06b2a36390e1bd1c85b3ca4ed2af83b9103e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "614e3baba257933225f87ef25a376bfbcba068dc3dc8de532e0d299a3bada1ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "639a02566a91c1d3ca59a3c179cf25ac4bbdf7a6691efcbad3c0952e270ca0c3"
    sha256 cellar: :any,                 x86_64_linux:  "b2060473d7cfcf90b9d5f81b05d09dc42c5b1f328bd015850c4abc156e96a6e2"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ruby" => :build # same Ruby as asciidoctor

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", formula_opt_libexec("asciidoctor")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("#{bin}/reposurgeon read list")
  end
end
