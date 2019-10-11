class S3cmd < Formula
  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://downloads.sourceforge.net/project/s3tools/s3cmd/2.0.2/s3cmd-2.0.2.tar.gz"
  sha256 "9f244c0c10d58d0ccacbba3aa977463e32491bdd9d95109e27b67e4d46c5bd52"
  revision 1
  head "https://github.com/s3tools/s3cmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c9218029b1ab059996b6c2e841fd93d69e4bf08e810b3aff6fa4be59416f17d" => :catalina
    sha256 "189112abb6e81acbbbd4977a3d573cf090dd7c85fee032642c5a9164ccb03046" => :mojave
    sha256 "182902e2ea25497262b58393a95b34a0961a1d83dc2702d357c5f3d06d1baecf" => :high_sierra
    sha256 "182902e2ea25497262b58393a95b34a0961a1d83dc2702d357c5f3d06d1baecf" => :sierra
  end

  depends_on "python"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/84/30/80932401906eaf787f2e9bd86dc458f1d2e75b064b4c187341f29516945c/python-magic-0.4.15.tar.gz"
    sha256 "f3765c0f582d2dfc72c15f3b5a82aecfae9498bd29ca840d72f37d7bd38bfcd5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage { system "python3", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    system bin/"s3cmd", "--help"
  end
end
