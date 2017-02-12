class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://files.pythonhosted.org/packages/7f/3b/24b44d91eb591f75a658928fc228cbe6571d499a8778730f9ddae389ca5e/vdirsyncer-0.14.1.tar.gz"
  sha256 "c51734cdbaf4ede98c375f87bc7a673032a4026378d4963cf9b7a1265d008e10"
  head "https://github.com/pimutils/vdirsyncer"

  bottle do
    sha256 "f5f9be51d3869dee5df3008901a0226bfce57af667a9cb4a9548968b0bafb335" => :sierra
    sha256 "4d05430dbdbbf0547e53c5509f98f27098cb49052a99c6e3c11ea901a294ae4c" => :el_capitan
    sha256 "0690da8353ffc68460046769229a7004a09391f3b48d741278302bf6487c8e01" => :yosemite
  end

  option "with-remotestorage", "Build with support for remote-storage"

  depends_on :python3

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/b7/71/d029ea00ede6c1fd307c8d87cd7aac90c1a7ed8dec2ede5dc115e254fade/click-log-0.1.8.tar.gz"
    sha256 "57271008c12e2dc16d413373bedd7fd3ff17c57434e168650dc27dfb9c743392"
  end

  resource "click-threading" do
    url "https://files.pythonhosted.org/packages/ef/67/7d75738e83b4d7f30242ed1e4379e4207da5d0c0aa9876148778790433f6/click-threading-0.4.2.tar.gz"
    sha256 "400b0bb63d9096b6bf2806efaf742a1cc8b6c88e0484f0afe7d7a7f0e9870609"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/59/78/1d391d30ebf74079a8e4de6ab66fdca5362903ef2df64496f4697e9bb626/requests-toolbelt-0.7.0.tar.gz"
    sha256 "33899d4a559c3f0f5e9fbc115d337c4236febdc083755a160a4132d92fc3c91a"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources

    prefix.install "contrib/vdirsyncer.plist"
    inreplace prefix/"vdirsyncer.plist" do |s|
      s.gsub! "@@WORKINGDIRECTORY@@", bin
      s.gsub! "@@VDIRSYNCER@@", bin/name
      s.gsub! "@@SYNCINTERVALL@@", "60"
    end
  end

  def post_install
    inreplace prefix/"vdirsyncer.plist", "@@LOCALE@@", ENV["LC_ALL"] || ENV["LANG"] || "en_US.UTF-8"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/vdirsyncer/config").write <<-EOS.undent
      [general]
      status_path = #{testpath}/.vdirsyncer/status/
      [pair contacts]
      a = contacts_a
      b = contacts_b
      collections = ["from a"]
      [storage contacts_a]
      type = filesystem
      path = ~/.contacts/a/
      fileext = .vcf
      [storage contacts_b]
      type = filesystem
      path = ~/.contacts/b/
      fileext = .vcf
    EOS
    (testpath/".contacts/a/foo/092a1e3b55.vcf").write <<-EOS.undent
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name Ö φ 風 ض
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    (testpath/".contacts/b/foo/").mkpath
    system "#{bin}/vdirsyncer", "discover"
    system "#{bin}/vdirsyncer", "sync"
    assert_match /Ö φ 風 ض/, (testpath/".contacts/b/foo/092a1e3b55.vcf").read
  end
end
