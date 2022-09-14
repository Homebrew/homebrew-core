class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/2d/b0/ffe9e812fa710579d07369763262e418cadb2a99fc5d0ec0d685c7f33a69/todoman-4.1.0.tar.gz"
  sha256 "ce3caa481d923e91da9b492b46509810a754e2d3ef857f5d20bc5a8e362b50c8"
  license "ISC"
  revision 1
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38d4c571efa7c25b1b44b44222ba42be1d488bd8dfcfdb90e000c86eba7dbfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc56a4c68161b390101745201298401d8d191df4f008646691bfa391ea7f10f6"
    sha256 cellar: :any_skip_relocation, monterey:       "848a0f885428cf7cf8bc849cc5dd794d8a687b19432f92f382604309498f7dfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "71b03101fbe5f053e86d33b07e9fc1ec851d15476bb9cfa5c18d290d6267ffcb"
    sha256 cellar: :any_skip_relocation, catalina:       "f9e24586502750b1a3338e1c935e57a823bda1a83f9f2b26ab7f6ebca87ce769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715db55e55809a33bd410ab3726fb35f6a203504013d4e992d2a8c4fa8971e52"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python@3.10"
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
    url "https://files.pythonhosted.org/packages/8a/b6/e7d99d1cc225a069f3f7a906a213cb1a0148dac27119290c41dc257ffe53/humanize-3.13.1.tar.gz"
    sha256 "12f113f2e369dac7f35d3823f49262934f4a22a53a6d3d4c86b736f50db88c7b"
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

    bash_completion.install "contrib/completion/bash/_todo" => "todo"
    zsh_completion.install "contrib/completion/zsh/_todo"
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
