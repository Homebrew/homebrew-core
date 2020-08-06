class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://rossmacarthur.github.io/sheldon"
  url "https://github.com/rossmacarthur/sheldon/archive/0.5.3.tar.gz"
  sha256 "e471dd1ce97587b373313e2cd463a145db0f72573a22aae5a605f3b676258164"
  # license ["Apache-2.0", "MIT"] - pending https://github.com/Homebrew/brew/pull/7953
  license "Apache-2.0"
  head "https://github.com/rossmacarthur/sheldon.git"

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--home", testpath, "--root", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end
