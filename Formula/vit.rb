class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://github.com/scottkosty/vit/archive/v2.0.0.tar.gz"
  sha256 "0c8739c16b5922880e762bd38f887240923d16181b2f85bb88c4f9f6faf38d6d"
  head "https://github.com/scottkosty/vit.git", :branch => "2.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "40e61e0d222aa0cdf33251b796d827d739056dd7f475b07c1d9f6befea3334c6" => :catalina
    sha256 "dabf6d97c4af518bad19d873777ead55122b44656eaf49735966f900c225cbac" => :mojave
    sha256 "ac57f8e4f66af27f973736de36a02ba7e2f08cc4b729a904e8fe960b2ed30341" => :high_sierra
    sha256 "7b41d373de2b877ec5b91b47e36b694ea3e966822e77697948e91861dd52725c" => :sierra
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
      sleep 1
      Process.kill "TERM", pid
    end
    assert_predicate testpath/".task", :exist?
  end
end
