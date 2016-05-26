# coding: utf-8
class Vdirsyncer < Formula
  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://pypi.python.org/packages/39/e5/1e7097b5f0cd6de79ec9014f162a6000b77ca2a369ea8a1588a2eebff570/vdirsyncer-0.11.0.tar.gz"
  sha256 "dbe1d139abf576ccf0b8220a30c80803c7ecaa52c7088241565c379cc4dcc0ad"
  head "https://github.com/pimutils/vdirsyncer"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd3a68144c85441f022c795ec339897c3db4f6a002ce2bdd226e8784f6297856" => :el_capitan
    sha256 "fa5fbc3f72399b0d52309e3c3bd1b24f4b91fa8a09e44eda65d5652fae7fb583" => :yosemite
    sha256 "c517ed6c8f4c5cac62751ea103f438739fdfb6c087f50d1f0f4cb07a5b7d78af" => :mavericks
  end

  option "with-remotestorage", "Build with support for remote-storage"

  depends_on :python3

  resource "requests_oauthlib" do
    url "https://pypi.python.org/packages/source/r/requests-oauthlib/requests-oauthlib-0.6.1.tar.gz"
    sha256 "905306080ec0cc6b3c65c8101f471fccfdb9994c16dd116524fd3fc0790d46d7"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.3.tar.gz"
    sha256 "b720d9faabe193287b71e3c26082b0f249501288e153b7e7cfce3bb87ac8cc1c"
  end

  resource "click_threading" do
    url "https://pypi.python.org/packages/source/c/click-threading/click-threading-0.1.2.tar.gz"
    sha256 "85045457e02f16fba3110dc6b16e980bf3e65433808da2b550dd513206d9b94a"
  end

  resource "click_log" do
    url "https://pypi.python.org/packages/source/c/click-log/click-log-0.1.3.tar.gz"
    sha256 "fd8dc8d65947ce6d6ee8ab3101fb0bb9015b9070730ada3f73ec761beb0ead4d"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "requests-toolbelt" do
    url "https://pypi.python.org/packages/source/r/requests-toolbelt/requests-toolbelt-0.6.0.tar.gz"
    sha256 "cc4e9c0ef810d6dfd165ca680330b65a4cf8a3f08f5f08ecd50a0253a08e541f"
  end

  resource "atomicwrites" do
    url "https://pypi.python.org/packages/source/a/atomicwrites/atomicwrites-0.1.9.tar.gz"
    sha256 "7cdfcee8c064bc0ba30b0444ba0919ebafccf5b0b1916c8cde07e410042c4023"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"
    rs = %w[click click_threading click_log requests requests-toolbelt atomicwrites]
    rs << "requests_oauthlib" if build.with? "remotestorage"
    rs.each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

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
