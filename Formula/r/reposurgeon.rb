class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.11/reposurgeon-5.11.tar.gz"
  sha256 "c51bfb9e9e2af6537224b1973872761031250ceadbebf1e292534870e54bdbc0"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e72a28d76a4ea2fff48cead6f389829c095f09f8e87f36dd50ae7697a019ab3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da1e17c072e4d4ad3e20eff57620f073bb50e1060c432ebc4c23584a641ea259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30e71b3c3011900b0d875ce70b02fedf30aa53c3640e1cacc37a4ff3c29a35ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a4f4b374ae4d599392161d01311b550d640229b55a365ebf9147600fe6f2852"
    sha256 cellar: :any,                 x86_64_linux:      "d1c94e23a267b1e85c8c20d723ebfdc96143637053eb38957f91e4b1f710aeb6"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ruby" => :build # same Ruby as asciidoctor

  on_linux do
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
