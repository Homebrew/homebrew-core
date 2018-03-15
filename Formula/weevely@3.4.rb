class WeevelyAT34 < Formula
  desc "Weaponized web shell"
  homepage "https://github.com/epinna/weevely3"
  url "https://github.com/epinna/weevely3/archive/v3.4.tar.gz"
  sha256 "86331c4c222dbc940bfdc8a12bfae0284ca369216e8f95ff136b6a1db99b0a33"

  depends_on "python@2"

  # Python requirements.txt
  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/c7/21/8911c1b4aab57b891a54bcb6b1fab2ef59e80a78f7f699dd3d162ddda87f/prettytable-0.7.tar.bz2"
    sha256 "bd3ee580540e80a90f463d6f83178aaa5c9900f310c65ad550e4bb116ffc8a16"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz"
    sha256 "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/7d/38/edca891ce16827a1de45cc347e4b6c22311eba25838b9825a5e6c48cf560/PySocks-1.6.7.tar.gz"
    sha256 "d00329f27efa157db7efe3ca26fcd69033cd61f83822461ee3f8a353b48e33cf"
  end

  resource "readline" do
    url "https://files.pythonhosted.org/packages/f4/01/2cf081af8d880b44939a5f1b446551a7f8d59eae414277fd0c303757ff1b/readline-6.2.4.1.tar.gz"
    sha256 "e00f86e03dfe52e7d1502cec5c64070b32621c85509c0081a4cfa6a0294bd107"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib64/python2.7/site-packages"

    %w[PrettyTable Mako PyYAML python-dateutil PySocks readline].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    (bin/"weevely").write <<~EOS
      #!/usr/bin/env bash
      cd #{libexec} && PYTHONPATH=#{ENV["PYTHONPATH"]} python2 weevely.py "$@"
    EOS

    libexec.install Dir["*"]
  end

  test do
    system "#{bin}/weevely", "generate", "password123", "#{testpath}/agent.php"
  end
end
