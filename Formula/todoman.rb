class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/57/54/04a7c526a466932cf8a72a5b164befe7ec43fe176d89210fa9aafacd99ce/todoman-4.0.1.tar.gz"
  sha256 "ec88f8009321e77deb0ae682f7d036c139edf4175f8413011b532905c6e7d2b1"
  license "ISC"
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0db45e69c952187fde65dbfb4c5fd18aac7be3c53f69bbb2ac0c0ebeda4ad54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7ad318c91c4605aaf963c4649d6b4da7c2b91f02d0a0e82b0237468a81c8ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "909909d657df782b0ab268c3436e2431d51f36d04171c9c752c78443ea5700a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cff83b0ba438dd9336af01a9fe5a7f25d54749f3192e8ff3a86483df6c4bc08"
    sha256 cellar: :any_skip_relocation, catalina:       "85c8a6adc87637301cc986d2d044cee74f4503d826803b0effe8d67a214918eb"
    sha256 cellar: :any_skip_relocation, mojave:         "44ea3d0d4e8e165fbb9905b371c5c411de0f0d94eddc87a93060b60383ab1844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a443022b007961186278490daa28d7b93778bf026839b9c5a636ba6534ae24"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  conflicts_with "devtodo", because: "both install a `todo` binary"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/55/8d/74a75635f2c3c914ab5b3850112fd4b0c8039975ecb320e4449aa363ba54/atomicwrites-1.4.0.tar.gz"
    sha256 "ae70396ad1a434f9c7046fd2dd196fc04b12f9e91ffb859164193be8b6168a7a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/22/44/3d73579b547f0790a2723728088c96189c8b52bd2ee3c3de8040efc3c1b8/click-log-0.3.2.tar.gz"
    sha256 "16fd1ca3fc6b16c98cea63acf1ab474ea8e676849dc669d86afafb0ed7003124"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/4f/95/e097e65913e9b5ce68a576cf3ea364eb240973cc15c6a8184047a3571290/humanize-3.12.0.tar.gz"
    sha256 "5ec1a66e230a3e31fb3f184aab9436ea13d4e37c168e0ffc345ae5bb57e58be6"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/1e/4b/b9e53b2fc4f7942c5698842005ad9e55dd4d932434f5bd1cf8acf3d06b01/icalendar-4.0.9.tar.gz"
    sha256 "cc73fa9c848744843046228cb66ea86cd8c18d73a51b140f7c003f760b84a997"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/todoman/config.py").write <<~EOS
      path = "#{testpath}/.calendar/*"
      date_format = "%Y-%m-%d"
      default_list = "Personal"
    EOS
    (testpath/".calendar/Personal").mkpath
    system "#{bin}/todo", "new", "newtodo"
    assert_match "newtodo", shell_output("#{bin}/todo list")
  end
end
