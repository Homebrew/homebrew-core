class Ry < Formula
  desc "Ruby virtual env tool"
  homepage "https://github.com/jneen/ry"
  url "https://github.com/jneen/ry/archive/v0.5.2.tar.gz"
  sha256 "b53b51569dfa31233654b282d091b76af9f6b8af266e889b832bb374beeb1f59"
  license "MIT"
  head "https://github.com/jneen/ry.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4df5abf69ebfc48335682ce491e2dec93750d1f7247fcec40f9c32fa16653895"
    sha256 cellar: :any_skip_relocation, big_sur:       "3ad95cc81d14e2844234bec25236dca63e31404dfe7e57bef41ab3e4a638047a"
    sha256 cellar: :any_skip_relocation, catalina:      "b82b9243f4e89e24608f21a9a46e55cad5708224749ee07da18841c3d50e38d2"
    sha256 cellar: :any_skip_relocation, mojave:        "835c360df374f5ca94a753b1ce79ba61dfc9fc14e54a2bf064367b9094909677"
    sha256 cellar: :any_skip_relocation, high_sierra:   "3e2e0b1e4104b9856ef6f5ad05caa4100ba209850c84c1db759f788eed042740"
    sha256 cellar: :any_skip_relocation, sierra:        "3e2e0b1e4104b9856ef6f5ad05caa4100ba209850c84c1db759f788eed042740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff90c674fd9f8f96903b8e1d51a24fe2a201e9597a422b10828f867f99f939b"
    sha256 cellar: :any_skip_relocation, all:           "9a47d208b05960d9d84c8b43dca7e2ea652ae07972d5e25e86ea386891b418ec"
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
    assert_predicate testpath/"rubies", :exist?
  end
end
