class Theharvester < Formula
  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/3.0.6.tar.gz"
  sha256 "a8ee1d28ae6c82ea3eb9ccf3eee23d2adc749672c6e0497a62f8f1c2ab395d2b"
  head "https://github.com/laramies/theHarvester.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dea5bd671b9024d0668cb6c29e69f9cc75fdbe98d706959891fc2a1097ea800b" => :mojave
    sha256 "834e9cc62f3ac842c9ee7ddefe26930d406eb6c7b45dc121378575b624e4af9c" => :high_sierra
    sha256 "834e9cc62f3ac842c9ee7ddefe26930d406eb6c7b45dc121378575b624e4af9c" => :sierra
  end

  depends_on "python"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/88/df/86bffad6309f74f3ff85ea69344a078fc30003270c8df6894fca7a3c72ff/beautifulsoup4-4.6.3.tar.gz"
    sha256 "90f8e61121d6ae58362ce3bed8cd997efb00c914eae0ff3d363c32f9a9822d10"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    libexec.install Dir["*"]
    (libexec/"theHarvester.py").chmod 0755
    (bin/"theharvester").write_env_script("#{libexec}/theHarvester.py", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/theharvester -d brew.sh -l 1 -b pgp 2>&1")
    assert_match "security@brew.sh", output
  end
end
