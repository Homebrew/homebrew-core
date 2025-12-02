class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.3/reposurgeon-5.3.tar.gz"
  sha256 "a13e758e6bba5f4d17cdfa0ad8956bb864f336ba248b175353f741c3e5d3b089"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "889508d576ab7da93911aaa8975968101cb229b79f80f3d7ad1a9602d7759568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "102e0f3f46f350bfd96d6568ad92250a6779ec45cb0608c5b96eeee7acb113e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5050fc7b8b308327099fc78cfffeff27c0e41f63db65eb8b5d94648c51f88983"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6045878a2a1f779ed09291a9c6d21eff4698be4377a7b6f958ef17faf3017c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "479f8b063e2fb806b3b2585bb65fb65308b0209b3c7687d5d3bb44ff641d131f"
    sha256 cellar: :any_skip_relocation, ventura:       "97eba5c7136a5397bdf4ed46af8a7068edf5710e1d0c893081078cc64eaf5fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52b7350eaacb2a1a4203d7927265fad7e1f48f3abee399db014f357e7ef12b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79f22e49216e32de6b2e6e1575dae5a1d3c7dc140bd672ecbe203862fa30b08"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  uses_from_macos "ruby"

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
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
