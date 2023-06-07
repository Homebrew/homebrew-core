class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/4.37/reposurgeon-4.37.tar.gz"
  sha256 "0173bb38d9c92ab67613924bfd803cf598b8a827c0ecfb7a7a3d316e99722f89"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33d4928a6c0dab4f053ef00b2fd405b508a15c34078b591110ff3a045fd988ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229269fedc64be3cbfc3c9aaccc32e57e62158326b70a1f78380427bcfcbae8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adb50234d9eb480d193acd6bb939823b2541b8c97597de5c73e24021f04aa7ac"
    sha256 cellar: :any_skip_relocation, ventura:        "c25bfc906bbe3261fa40dc1b4bf715baaf38896d6e8c583b373e5af4d6c6d566"
    sha256 cellar: :any_skip_relocation, monterey:       "849d1fa75f7d16c8530afa01c31d934fb48fc1de8cbbf0997ea6f4a2f1ec8c81"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ff8adfc6889b2070b05ba7a04088ca6eeb2882a30b5c0747308109a9c3dc2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e52e089038b286534bcbee9fe7a19319b5decb5fe893ed29dd4306073ed805"
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
