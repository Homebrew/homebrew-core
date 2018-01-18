class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/b4/19/9d6fda7af4b17bd75c97efecfbc478f9e39af8c5228d644fc495c646c433/todoman-3.3.0.tar.gz"
  sha256 "dbbe12195d292b48cde8dd9324a14e695cdcb79f3800ddf5f29c8c71bc133952"
  head "https://github.com/pimutils/todoman.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bd06a5dbda08472b091527af9aabe66d4d6f0888ba28294392d1262041cad77" => :high_sierra
    sha256 "11f6fe4822bdcfd98401fe22a8adeaac06a620b0b6d43324fa31f1ebf8f58849" => :sierra
    sha256 "1a60142bb115b2d6c63c0a0a557d1db9471417390cdcf6b50a9ad68411b7b26c" => :el_capitan
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

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/31/b7/95ad377ec87570d2e80f90e8ffe574a3d907a97c2b6613a17b6f81e0dda5/click-log-0.2.1.tar.gz"
    sha256 "493af4fde9999fa3a15696a1c3c7ace394296542a035caaf5854b32140413de4"
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
    url "https://files.pythonhosted.org/packages/96/f5/33e39d653e672d5110af87f4814570e21bdfea82d21cbc91ee34585aa04e/icalendar-4.0.0.tar.gz"
    sha256 "367a48b779b9d19d3a59f681bd159897507d7013827f91265bfada2bfa48d749"
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
    url "https://files.pythonhosted.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa/pytz-2017.3.zip"
    sha256 "fae4cffc040921b8a2d60c6cf0b5d662c1190fe54d718271db4eb17d44a185b7"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/26/28/ee953bd2c030ae5a9e9a0ff68e5912bd90ee50ae766871151cd2572ca570/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/12/c2/11d6845db5edf1295bc08b2f488cf5937806586afe42936c3f34c097ebdc/tabulate-0.8.2.tar.gz"
    sha256 "e4ca13f26d0a6be2a2915428dc21e732f1e44dad7f76d7030b2ef1ec251cf7f2"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c9/07/8e1bfc4f6166828e449814681ef57003c36ba7989e7c941e951ca9447f08/urwid-2.0.0.tar.gz"
    sha256 "2ec42d29cd173a7126817174468614a17bcd9bafc0bdd47918f4e473301b4761"
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
