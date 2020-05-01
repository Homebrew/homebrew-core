class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://github.com/scottkosty/vit/archive/v2.0.0.tar.gz"
  sha256 "0c8739c16b5922880e762bd38f887240923d16181b2f85bb88c4f9f6faf38d6d"
  revision 1
  head "https://github.com/scottkosty/vit.git", :branch => "2.x"

  bottle do
    cellar :any_skip_relocation
    sha256 "9eb4a22fa79769bda35c5f7e7a7be6a4295b846b497fd6f6d3384e7128b43e2b" => :catalina
    sha256 "7cef7640cbb5b6fa0c5c3cefbcfeb578e667c159229bbc723ddaf15c561d76dd" => :mojave
    sha256 "220f52f07f57fc07e7805a5d3162e9fbde3f08b8255177b6cefddb4748f6988b" => :high_sierra
  end

  depends_on "python@3.8"
  depends_on "task"

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/82/c3/534ddba230bd4fbbd3b7a3d35f3341d014cca213f369a9940925e7e5f691/pytz-2019.3.tar.gz"
    sha256 "b02c06db6cf09c12dd25137e563b31700d3b80fcc4ad23abb7a315f2789819be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/ae/23/3de1856314e8aa87330c57b5c6f8c8738c4fca72bc96fa10b54f7524c752/tasklib-1.3.0.tar.gz"
    sha256 "5b478c53d5b531e072d1374bb4763249d137a094d93621e6ebe2f3f10c52d9a7"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/c6/52/5ec375d4efcbe4e31805f3c4b301bdfcff9dcbdb3605d4b79e117a16b38d/tzlocal-2.0.0.tar.gz"
    sha256 "949b9dd5ba4be17190a80c0268167d7e6c92c62b30026cf9764caf3e308e5590"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
    sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
  end

  def install
    virtualenv_install_with_resources
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
