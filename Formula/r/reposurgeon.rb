class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.6/reposurgeon-5.6.tar.gz"
  sha256 "86340ee2951f976635d92fbc73fc0c3f757f3ecf64f179619ce1721a729fee62"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3c96bb53050478015b609ca925ff57d55d937d40861f2c32896603c3346df6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f902e52be5a0ab80a636d2986c6896df8812fb5b3748c593aa1ff4cda648dc31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21beb2b98d3acbecd01dd10af0d45dd91e508bfeb04b1d570363a52ca3ef9638"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c3eec7f8810c20f4f226a7514cb3e0743cc03907d4a38ae8bcf2126fc457112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b91798fdffaae0627eca902b5e8851bf0c13250ba9bc5b7f0903618e6ca99395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d39a7a069111372335bf06b705ab7b66e7a4cafda83ba725c846fd9dfa71fe65"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build

  uses_from_macos "ruby"

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
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
