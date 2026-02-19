class St < Formula
  desc "Statistics from the command-line"
  homepage "https://github.com/nferraz/st"
  url "https://github.com/nferraz/st/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "c02a16f67e4c357690a5438319843149fd700c223128f9ffebecab2849c58bb8"
  license "MIT"
  revision 1
  head "https://github.com/nferraz/st.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dea11b6d608a0978854f5f19a0d6941086f6b970c5919dd268a003c8ef4d2181"
  end

  conflicts_with "schemathesis", because: "both install `st` binaries"

  def install
    ENV.prepend_create_path "PERL5LIB", lib/"perl5/"

    args = %W[
      INSTALL_BASE=#{prefix}
      INSTALLSITEMAN1DIR=#{man1}
      INSTALLSITEMAN3DIR=#{man3}
      MAN1EXT=1
    ]
    system "perl", "Makefile.PL", *args
    system "make", "install"

    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]

    # Build an `:all` bottle
    chmod 0755, [bin, lib/"perl5/App", share, share/"man", man1, man3] # permissions match
  end

  test do
    (testpath/"test.txt").write((1..100).map(&:to_s).join("\n"))
    assert_equal "5050", pipe_output("#{bin}/st --sum test.txt").chomp
  end
end
