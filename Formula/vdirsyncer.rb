class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://github.com/pimutils/vdirsyncer.git",
      tag:      "0.16.8",
      revision: "b5dd0929d009b7b07f72903dd6fb82815f45bdd8"
  revision 2
  head "https://github.com/pimutils/vdirsyncer.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f1ede11a17630f2ea0da1ec356015fa454b62d9e5eebf17ad38e89021c6cc739" => :big_sur
    sha256 "a516d7f9f4a99067fe1908faf3cd09849ad0164bfb56a05e11b249c10b13123e" => :arm64_big_sur
    sha256 "d87dd5b19a013e2099aa915c02caea1bf5ba5bce1ed9fdb1c599900da98f1574" => :catalina
    sha256 "999dcfe149cd6cb2a072006159ce83e680e2da30431d28b380a0dd3549b59d98" => :mojave
    sha256 "b48980fb7b1f225d07e847ab50b2a6c6e6bdca56386f902982163d7cfb11f6e7" => :high_sierra
  end

  depends_on "python@3.9"

  # from https://github.com/pimutils/vdirsyncer/pull/830
  # remove in next release
  patch do
    url "https://github.com/pimutils/vdirsyncer/commit/7577fa21177442aacc2d86640ef28cebf1c4aaef.patch?full_index=1"
    sha256 "3fe0b07e6a1f5210a51af4240e54ee2fe32936680f7ae518e40424531b657844"
  end

  def install
    venv = virtualenv_create(libexec, "python3.9")
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
    (testpath/".config/vdirsyncer/config").write <<~EOS
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
    (testpath/".contacts/a/foo/092a1e3b55.vcf").write <<~EOS
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
