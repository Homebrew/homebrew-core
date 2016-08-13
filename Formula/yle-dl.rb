class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.10.3.tar.gz"
  sha256 "bf61ecde5de2e42faa440f3873d4887d09865fe4e2de7c5441fb49adbf131a4d"

  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a7c736a485e1530afa197bb86bf00eae7bef811bf424f5df41d46835cb68a09" => :el_capitan
    sha256 "79033b8fed236e26f59fefa852feee663b88a1c7ffc04249d63b8c5f8d71fbfa" => :yosemite
    sha256 "4b4758c6788e222691d33e2d43dcdc1990d820dd91659aab3425ea5b5d5513fd" => :mavericks
  end

  depends_on "rtmpdump"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "homebrew/php/php70-mcrypt" => :optional
  depends_on "homebrew/php/php56-mcrypt" => :optional
  depends_on "homebrew/php/php55-mcrypt" => :optional
  depends_on "homebrew/php/php54-mcrypt" => :optional
  depends_on "homebrew/php/php53-mcrypt" => :optional

  resource "AdobeHDS.php" do
    # NOTE: yle-dl always installs the HEAD version of AdobeHDS.php. We use a specific commit.
    # Check if there are bugfixes at https://github.com/K-S-V/Scripts/commits/master/AdobeHDS.php
    url "https://raw.githubusercontent.com/K-S-V/Scripts/3a9b748f957a921c5f846b3ebc7c99bb8255d2e0/AdobeHDS.php"
    sha256 "45adf9b03dc991fcf6a44bb4cf62dd3777bf69647f1a98290e160a2bf89ebc2d"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("pycrypto").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    resource("AdobeHDS.php").stage(pkgshare)
    system "make", "install", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"

    # change shebang to plain python (python2 is not guaranteed to exist)
    inreplace bin/"yle-dl", "#!/usr/bin/env python2", "#!/usr/bin/env python"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    yle-dl requires the mcrypt PHP module which you can either install manually or install
    mcrypt from the PHP homebrew tap. You can also install yle-dl with one of optional dependencies
    which to automatically tap the php tap and download mcrypt module for you.

      brew info yle-dl

    for further info.
    EOS
  end

  test do
    assert_equal "Traileri: 3 minuuttia-2012-05-30T10:51:00+03:00\n",
                 shell_output("#{bin}/yle-dl --showtitle http://areena.yle.fi/1-1570236")
  end
end
