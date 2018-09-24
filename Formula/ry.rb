class Ry < Formula
  desc "Ruby virtual env tool"
  homepage "https://github.com/jayferd/ry"
  url "https://github.com/jayferd/ry/archive/v0.5.2.tar.gz"
  sha256 "b53b51569dfa31233654b282d091b76af9f6b8af266e889b832bb374beeb1f59"
  head "https://github.com/jayferd/ry.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "022769e51adb7393c5b418aef50911e96bb6bc43dfc7d81850b6e71cea7c3a2d" => :mojave
    sha256 "7d9631e41ff87b979c1d94ce1bfe1a710dd031e923b447332186678e68a0f523" => :high_sierra
    sha256 "2703cd68ac926b7bd8dac25c93054993706d32a4c9857b450eb19f88bdf81530" => :sierra
    sha256 "5b324970a3a3c806029241e1c5c453c900f16b3aec8e32bedc5d1a6abb5670c7" => :el_capitan
    sha256 "7b8c7549875ff9a303735ffae235f520fd85af5796953ab92949d2ec7d69ecc6" => :yosemite
    sha256 "c94e0176f99aaefcdc84ef95c081aa348177662e1b7f20d429a5c56a5b98ef40" => :mavericks
  end

  depends_on "bash-completion"
  depends_on "ruby-build"

  def install
    ENV["PREFIX"] = prefix
    ENV["BASH_COMPLETIONS_DIR"] = etc/"bash_completion.d"
    ENV["ZSH_COMPLETIONS_DIR"] = share/"zsh/site-functions"
    system "make", "install"
  end

  def caveats; <<~EOS
    Please add to your profile:
      which ry &>/dev/null && eval "$(ry setup)"

    If you want your Rubies to persist across updates you
    should set the `RY_RUBIES` variable in your profile, i.e.
      export RY_RUBIES="#{HOMEBREW_PREFIX}/var/ry/rubies"
  EOS
  end

  test do
    ENV["RY_RUBIES"] = testpath/"rubies"

    system bin/"ry", "ls"
    assert_predicate testpath/"rubies", :exist?
  end
end
