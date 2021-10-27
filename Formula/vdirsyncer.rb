class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://github.com/pimutils/vdirsyncer.git",
      tag:      "0.18.0",
      revision: "3191886658f7717c00ec013eb778bc1ced5cef0c"
  license "BSD-3-Clause"
  head "https://github.com/pimutils/vdirsyncer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f28e80d5fe2743220d9c8b673a45255ed688826587423288e1f052b8f80c94d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9948fcd51959d59226a3f7551ee1bce7ba44387aea0b3e038c93f2bf4c046e1"
    sha256 cellar: :any_skip_relocation, monterey:       "202306a14af3aab37e367d519aaf794c948fc3459684a2284ef9e2e0e2b85077"
    sha256 cellar: :any_skip_relocation, big_sur:        "bca2caf2e456db762a65b666f786c0d6c5f500643969c7e15d5546ea336649f6"
    sha256 cellar: :any_skip_relocation, catalina:       "bca2caf2e456db762a65b666f786c0d6c5f500643969c7e15d5546ea336649f6"
    sha256 cellar: :any_skip_relocation, mojave:         "bca2caf2e456db762a65b666f786c0d6c5f500643969c7e15d5546ea336649f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3092fcf128119cf7a6a8131c4d16df5e44ab56a7fa07e2a661806c4f2ad2b9"
  end

  depends_on "python@3.10"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    venv = virtualenv_create(libexec, "python#{xy}")
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
    assert_match "Ö φ 風 ض", (testpath/".contacts/b/foo/092a1e3b55.vcf").read
  end
end
