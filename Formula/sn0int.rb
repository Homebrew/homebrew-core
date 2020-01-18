class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.15.0.tar.gz"
  sha256 "6fc1819eda57dff5e580ce9980a8526bb076f96845adfd3f41566416ffdf729c"

  bottle do
    cellar :any_skip_relocation
    sha256 "54f505e305d3b379d2f12b73fe8831fa57b793920f3540801846a6d4cbf97639" => :catalina
    sha256 "d1178042a9a31fdef54d486fb8f69a84370714bb318c85ab2ecafb0265a0728e" => :mojave
    sha256 "29241df8f8534c61db50b8cbb22857fdac5880eea4d3e756606a729039cd743e" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    system "#{bin}/sn0int completions bash > sn0int.bash"
    system "#{bin}/sn0int completions fish > sn0int.fish"
    system "#{bin}/sn0int completions zsh > _sn0int"

    bash_completion.install "sn0int.bash"
    fish_completion.install "sn0int.fish"
    zsh_completion.install "_sn0int"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system "#{bin}/sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
