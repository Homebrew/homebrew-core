class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/releases/download/v2.0.2/vcsh-2.0.2.tar.xz"
  sha256 "3ffc0bbb43c76620c8234c98f4ae94d0a99d24bb240497aab730979a8d23ad61"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6adf58cb690fa63602d8056d347bf55dde6ebd090c6f82d1bbbbc78b137d93b"
  end

  def install
    system "./configure", "--with-zsh-completion-dir=#{zsh_completion}",
                          "--with-bash-completion-dir=#{bash_completion}",
                          *std_configure_args
    system "make", "install"

    # Remove references to git shim
    inreplace bin/"vcsh", %r{#{HOMEBREW_SHIMS_PATH}/[^/]+/super/git}o, "git"
  end

  test do
    assert_match "Initialized empty", shell_output("#{bin}/vcsh init test").strip
  end
end
