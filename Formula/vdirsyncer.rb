class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://github.com/pimutils/vdirsyncer.git",
      :tag => "0.16.1",
      :revision => "6e27770271eaf4745af5ff270e0c858bdd1c69ff"
  head "https://github.com/pimutils/vdirsyncer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef23661a0e406b0997df2365f49c2087d95a6128b841938c1cc4d433b675d479" => :sierra
    sha256 "4f83be3dc39ef0dfba9af3010790e60f5785b7532eefb4b3da7b37b293206e85" => :el_capitan
    sha256 "b0cda175daf3eb40f8c80103cc93f6f429331afbe938da0aeb7a59cc83109900" => :yosemite
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
