class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.3.1.tar.gz"
  sha256 "3d7a7784ed85dd5301f350a3d05eca839f24846997eb0a44b749467f0f4dd032"
  head "https://github.com/dduan/tre.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
