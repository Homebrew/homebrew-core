class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://github.com/mgedmin/restview"
  url "https://github.com/mgedmin/restview/archive/2.8.0.tar.gz"
  sha256 "fec5514f33c306fbd2fd93594307f367ee1fe5293de5ecc709046969c4af9bd5"

  depends_on python if MacOS.version <= :snow_leopard

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/d4/3f/d517089af35b01bb9bc4eac5ea04bae342b37a5e9abbb27b7c3ce0eae070/bleach-2.1.1.tar.gz"
    sha256 "760a9368002180fb8a0f4ea48dc6275378e6f311c39d0236d7b904fca1f5ea0d"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/17/ee/99e69cdcefc354e0c18ff2cc60aeeb5bfcc2e33f051bf0cc5526d790c445/html5lib-0.999999999.tar.gz"
    sha256 "ee747c0ffd3028d2722061936b5c65ee4fe13c8e4613519b4447123fc4546298"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "readme_renderer" do
    url "https://files.pythonhosted.org/packages/b6/a8/f27c15837fcbcb6110bd0f1dfa04b5fae658a1da3c07f186dba89818a613/readme_renderer-17.2.tar.gz"
    sha256 "9deab442963a63a71ab494bf581b1c844473995a2357f4b3228a1df1c8cba8da"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "sample" do
    url "https://raw.githubusercontent.com/mgedmin/restview/140e23ad6604d52604bc11978fd13d3199150862/sample.rst"
    sha256 "5a15b5f11adfdd5f895aa2e1da377c8d8d0b73565fe68f51e01399af05612ea3"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resources.reject { |r| r.name == "sample" }
    venv.pip_install_and_link buildpath
  end

  test do
    require "timeout"

    resource("sample").stage testpath

    begin
      Timeout.timeout(10) do
        system "#{bin}/restview", "#{testpath}/sample.rst"
      end
    rescue Timeout::Error
      true
    end
  end
end
