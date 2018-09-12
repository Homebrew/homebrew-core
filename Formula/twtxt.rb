class Twtxt < Formula
  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://github.com/buckket/twtxt/archive/v1.2.3.tar.gz"
  sha256 "73b9d4988f96cc969c0c50ece0e9df12f7385735db23190e40c0d5e16f7ccd8c"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "6c948ba92af7f299cc6acfdcdd6893a9b20780ef149b6fdb7d575e01c7ea0aaf" => :mojave
    sha256 "f963596e688a14b0623e9dea3eaf6409735c8368f3dce28de620f399717daa78" => :high_sierra
    sha256 "cb5e432d05084bfa411569f25516766f4f0daba7d6d290c027d285ff7db3e895" => :sierra
    sha256 "e5f0349895e6ace478d6e6d1821502fbc77232adb44a2f6467087518aa03eace" => :el_capitan
  end

  depends_on "python"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c0/b9/853b158f5cb5d218daaff0fb0dbc2bd7de45b2c6c5f563dff0ee530ec52a/aiohttp-2.3.10.tar.gz"
    sha256 "8adda6583ba438a4c70693374e10b60168663ffa6564c5c75d3c7a9055290964"

    # Python 3.7 compat
    patch :DATA
  end

  resource "async_timeout" do
    url "https://files.pythonhosted.org/packages/35/82/6c7975afd97661e6115eee5105359ee191a71ff3267fde081c7c8d05fae6/async-timeout-3.0.0.tar.gz"
    sha256 "b3c0ddc416736619bd4a95ca31de8da6920c3b9a140c64dbef2b2fa7bf521287"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/9d/b9/3cf1b908d7af6530209a7a16d71ab2734a736c3cdf0657e3a06d0209811e/multidict-4.3.1.tar.gz"
    sha256 "5ba766433c30d703f6b2c17eb0b6826c6f898e5f58d89373e235f07764952314"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/43/b8/057c3e5b546ff4b24263164ecda13f6962d85c9dc477fcc0bcdcb3adb658/yarl-1.2.6.tar.gz"
    sha256 "c8cbc21bbfa1dd7d5386d48cc814fe3d35b80f60299cdde9279046f399c3b0d8"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  # If the test needs to be updated, more users can be found here:
  # https://github.com/mdom/we-are-twtxt/blob/master/we-are-twtxt.txt
  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/"config").write <<~EOS
      [twtxt]
      nick = homebrew
      twtfile = twtxt.txt
      [following]
      abliss = https://abliss.keybase.pub/twtxt.txt#7a778276dd852edc65217e759cba637a28b4426b
    EOS
    (testpath/"twtxt.txt").write <<~EOS
      2016-02-05T18:00:56.626750+00:00  Homebrew speaks!
    EOS
    assert_match "PGP", shell_output("#{bin}/twtxt -c config timeline")
  end
end

__END__
diff --git a/setup.py b/setup.py
index 9ca33d1..05b65f3 100644
--- a/setup.py
+++ b/setup.py
@@ -63,8 +63,7 @@ with codecs.open(os.path.join(os.path.abspath(os.path.dirname(
 
 
 install_requires = ['chardet', 'multidict>=4.0.0',
-                    'async_timeout>=1.2.0', 'yarl>=1.0.0',
-                    'idna-ssl>=1.0.0']
+                    'async_timeout>=1.2.0', 'yarl>=1.0.0']
 
 
 def read(f):
