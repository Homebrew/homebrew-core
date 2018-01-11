class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://github.com/pimutils/todoman/releases/download/v3.2.4/todoman-3.2.4.tar.gz"
  sha256 "05264d7702b31f3f3e1b73e679d0cc0af563a34385e15b376a924891d56cf370"
  revision 1
  head "https://github.com/pimutils/todoman.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd6061a3790836cd3dbe364267461cf2b9984989587148c6553d59e3cf10a88f" => :high_sierra
    sha256 "d0f6294e4e4a7dbb43c221458d1a91ef77abe9fca2177a7fc0b3667871d5d106" => :sierra
    sha256 "5e9bd936abe30ba8fae7d720dda8dfbcbdc71ebf967d761fc4e3f82e9bb0b29a" => :el_capitan
  end

  depends_on "python3"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/70/ef/9ccc21d19376ff785d83f72f51203cb646546c994a79c60ad8cba9bd7ce5/icalendar-3.11.7.tar.gz"
    sha256 "ecadaec5b5ebbae19640dac65a11e0adeabfeb16fb342c1a853f4a8e520c0e2a"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/26/28/ee953bd2c030ae5a9e9a0ff68e5912bd90ee50ae766871151cd2572ca570/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/todoman/todoman.conf").write <<~EOS
      [main]
      path = #{testpath}/.calendar/*
      date_format = %Y-%m-%d
      default_list = Personal
    EOS
    (testpath/".calendar/Personal").mkpath
    system "#{bin}/todo", "new", "newtodo"
    assert_match "newtodo", shell_output("#{bin}/todo list")
  end
end
