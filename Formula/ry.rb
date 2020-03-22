class Ry < Formula
  desc "Ruby virtual env tool"
  homepage "https://github.com/jayferd/ry"
  url "https://github.com/jayferd/ry/archive/v0.5.2.tar.gz"
  sha256 "b53b51569dfa31233654b282d091b76af9f6b8af266e889b832bb374beeb1f59"
  head "https://github.com/jayferd/ry.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "b82b9243f4e89e24608f21a9a46e55cad5708224749ee07da18841c3d50e38d2" => :catalina
    sha256 "835c360df374f5ca94a753b1ce79ba61dfc9fc14e54a2bf064367b9094909677" => :mojave
    sha256 "3e2e0b1e4104b9856ef6f5ad05caa4100ba209850c84c1db759f788eed042740" => :high_sierra
    sha256 "3e2e0b1e4104b9856ef6f5ad05caa4100ba209850c84c1db759f788eed042740" => :sierra
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
