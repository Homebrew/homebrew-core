class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://github.com/scottkosty/vit/archive/v2.0.0.tar.gz"
  sha256 "0c8739c16b5922880e762bd38f887240923d16181b2f85bb88c4f9f6faf38d6d"
  head "https://github.com/scottkosty/vit.git", :branch => "2.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "9eb4a22fa79769bda35c5f7e7a7be6a4295b846b497fd6f6d3384e7128b43e2b" => :catalina
    sha256 "7cef7640cbb5b6fa0c5c3cefbcfeb578e667c159229bbc723ddaf15c561d76dd" => :mojave
    sha256 "220f52f07f57fc07e7805a5d3162e9fbde3f08b8255177b6cefddb4748f6988b" => :high_sierra
  end

  depends_on "python"
  depends_on "task"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/".vit").mkpath
    touch testpath/".vit/config.ini"
    touch testpath/".taskrc"

    require "pty"
    PTY.spawn(bin/"vit") do |_stdout, _stdin, pid|
      sleep 3
      Process.kill "TERM", pid
    end
    assert_predicate testpath/".task", :exist?
  end
end
