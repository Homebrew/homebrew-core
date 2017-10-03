class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://github.com/pimutils/vdirsyncer.git",
      :tag => "0.16.3",
      :revision => "cca412e7a8ce862a196ed19ba801886cda936f99"
  head "https://github.com/pimutils/vdirsyncer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "283b409780a2014426496375aa698e9a5bbdd0703056fb9b1d801f97b75061d5" => :high_sierra
    sha256 "fd94c0cb0877b1952b7a9357b18acca192d68571c39b8b50aa0d1b2c292ebfda" => :sierra
    sha256 "419b1b07223d00147e341661b7160e11140967270b48a1f7ec40f9a84579d8ac" => :el_capitan
    sha256 "4ccea7799bbe26786cb68c5fcb0b515ff03c3c3ce8bd38654bce715f9cac1e5b" => :yosemite
  end

  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "requests-oauthlib",
                              buildpath
    system libexec/"bin/pip", "uninstall", "-y", "vdirsyncer"
    venv.pip_install_and_link buildpath

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
      status_path = "#{testpath}/.vdirsyncer/status/"
      [pair contacts]
      a = "contacts_a"
      b = "contacts_b"
      collections = ["from a"]
      [storage contacts_a]
      type = "filesystem"
      path = "~/.contacts/a/"
      fileext = ".vcf"
      [storage contacts_b]
      type = "filesystem"
      path = "~/.contacts/b/"
      fileext = ".vcf"
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
