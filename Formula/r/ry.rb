class Ry < Formula
  desc "Ruby virtual env tool"
  homepage "https://github.com/jneen/ry"
  url "https://github.com/jneen/ry/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "b53b51569dfa31233654b282d091b76af9f6b8af266e889b832bb374beeb1f59"
  license "MIT"
  head "https://github.com/jneen/ry.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "8b92938f20452bf4ad49ef46d0788aac93d5b7f5846cfd3fbaa387da67a2e56e"
  end

  depends_on "bash-completion"
  depends_on "ruby-build"

  def install
    ENV["BASH_COMPLETIONS_DIR"] = prefix/"etc/bash_completion.d"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
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
    assert_path_exists testpath/"rubies"
  end
end
