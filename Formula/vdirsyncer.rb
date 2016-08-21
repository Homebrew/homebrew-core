class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://files.pythonhosted.org/packages/63/c0/8f2305a3a4cf0ed0b30b430f90064139fed5ea6081a99798c27e62c0ed93/vdirsyncer-0.12.1.tar.gz"
  sha256 "3fbba82d5c687238698799799521978bffe72f87b911a267a9c1933b10bd7df8"
  head "https://github.com/pimutils/vdirsyncer"

  bottle do
    cellar :any_skip_relocation
    sha256 "25588b4b1da499b3a8cd7a9f930c6c56d18ae4c51b20ad07c6d1daa25e696b7e" => :el_capitan
    sha256 "ddbdd6899ead9e37fcc65dac58d65edcffe7534d3928c12e3b816c6b494402d3" => :yosemite
    sha256 "6cfb0f35a259d63db3512d0db37931528f75af3135e1a74c3a1c9bab5ac73647" => :mavericks
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
    url "https://files.pythonhosted.org/packages/18/c6/ce0c132a90b5f5f52cce68292c8f0bee55b73994148bda0540f773922571/click-log-0.1.4.tar.gz"
    sha256 "dc6275b7d8f87512a22d9806ccc845f474825edd82ad37925a36ba156c887570"
  end

  resource "click-threading" do
    url "https://files.pythonhosted.org/packages/72/a5/0d72a73e085d8943c82dee5a0713ae1237f8cd59a0586fa87ecebb5320fe/click-threading-0.4.0.tar.gz"
    sha256 "1823fac05f6b7705ab15956512a06d1b634beb4bbf99e115cab4fc4f6d1436d3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
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
